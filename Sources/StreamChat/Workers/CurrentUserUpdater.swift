//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import CoreData
import Foundation

/// Updates current user data to the backend and updates local storage.
class CurrentUserUpdater: Worker {
    /// Updates the current user data.
    ///
    /// By default all data is `nil`, and it won't be updated unless a value is provided.
    ///
    /// - Parameters:
    ///   - currentUserId: The current user identifier.
    ///   - name: Optionally provide a new name to be updated.
    ///   - imageURL: Optionally provide a new image to be updated.
    ///   - privacySettings: The privacy settings of the user. Example: If the user does not want to expose typing events or read events.
    ///   - userExtraData: Optionally provide new user extra data to be updated.
    ///   - completion: Called when user is successfuly updated, or with error.
    func updateUserData(
        currentUserId: UserId,
        name: String? = nil,
        imageURL: URL? = nil,
        privacySettings: UserPrivacySettings? = nil,
        userExtraData: [String: RawJSON]? = nil,
        completion: ((Error?) -> Void)? = nil
    ) {
        let params: [Any?] = [name, imageURL, userExtraData]
        guard !params.allSatisfy({ $0 == nil }) else {
            log.warning("Update user request not performed. All provided data was nil.")
            completion?(nil)
            return
        }

        let payload = UserUpdateRequestBody(
            name: name,
            imageURL: imageURL,
            privacySettings: privacySettings.map { UserPrivacySettingsPayload(settings: $0) },
            extraData: userExtraData
        )

        apiClient
            .request(endpoint: .updateUser(id: currentUserId, payload: payload)) { [weak self] in
                switch $0 {
                case let .success(response):
                    self?.database.write({ (session) in
                        try session.saveCurrentUser(payload: response.user)
                    }) { completion?($0) }
                case let .failure(error):
                    completion?(error)
                }
            }
    }

    /// Registers a device for push notifications to the current user.
    /// `setUser` must be called before calling this.
    /// - Parameters:
    ///   - deviceId: The device id.
    ///   - pushProvider: The push provider.
    ///   - providerName: Name of the push configuration in dashboard. If nil, default configuration will be used.
    ///   - currentUserId: The current user identifier.
    ///   - completion: Called when device is successfully registered, or with error.
    func addDevice(
        deviceId: DeviceId,
        pushProvider: PushProvider,
        providerName: String? = nil,
        currentUserId: UserId,
        completion: ((Error?) -> Void)? = nil
    ) {
        database.write { (session) in
            try session.saveCurrentDevice(deviceId)
        }

        apiClient
            .request(
                endpoint: .addDevice(
                    userId: currentUserId,
                    deviceId: deviceId,
                    pushProvider: pushProvider,
                    providerName: providerName
                ),
                completion: { result in
                    if let error = result.error {
                        log.debug("Device token \(deviceId) failed to be registered on Stream's backend.\n Reason: \(error.localizedDescription)")
                        completion?(error)
                        return
                    }
                    log.debug("Device token \(deviceId) was successfully registered on Stream's backend.")
                    completion?(nil)
                }
            )
    }

    /// Removes a registered device from the current user.
    /// `setUser` must be called before calling this.
    /// - Parameters:
    ///   - id: Device id to be removed. You can obtain registered devices via `currentUser.devices`.
    ///   - currentUserId: The current user identifier.
    ///   If `currentUser.devices` is not up-to-date, please make an `fetchDevices` call.
    ///   - completion: Called when device is successfully deregistered, or with error.
    func removeDevice(id: DeviceId, currentUserId: UserId, completion: ((Error?) -> Void)? = nil) {
        database.write { (session) in
            session.deleteDevice(id: id)
        }

        apiClient
            .request(
                endpoint: .removeDevice(
                    userId: currentUserId,
                    deviceId: id
                ),
                completion: { result in
                    completion?(result.error)
                }
            )
    }

    /// Updates the registered devices for the current user from backend.
    /// - Parameters:
    ///     - currentUserId: The current user identifier.
    ///     - completion: Called when request is successfully completed, or with error.
    func fetchDevices(currentUserId: UserId, completion: ((Error?) -> Void)? = nil) {
        apiClient.request(endpoint: .devices(userId: currentUserId)) { [weak self] result in
            do {
                let devicesPayload = try result.get()
                self?.database.write({ (session) in
                    // Since this call always return all device, we want' to clear the existing ones
                    // to remove the deleted devices.
                    try session.saveCurrentUserDevices(devicesPayload.devices, clearExisting: true)
                }) { completion?($0) }
            } catch {
                completion?(error)
            }
        }
    }

    /// Marks all channels for a user as read.
    /// - Parameter completion: Called when the API call is finished. Called with `Error` if the remote update fails.
    func markAllRead(completion: ((Error?) -> Void)? = nil) {
        apiClient.request(endpoint: .markAllRead()) {
            completion?($0.error)
        }
    }
}
