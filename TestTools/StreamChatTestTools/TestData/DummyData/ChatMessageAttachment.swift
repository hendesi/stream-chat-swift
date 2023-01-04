//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamChat

extension AnyChatMessageAttachment {
    static func dummy(
        id: AttachmentId = .unique,
        type: AttachmentType = .image,
        payload: Data = "payload".data(using: .utf8)!,
        uploadingState: AttachmentUploadingState? = nil
    ) -> AnyChatMessageAttachment {
        AnyChatMessageAttachment(
            id: id,
            type: type,
            payload: payload,
            uploadingState: uploadingState
        )
    }
}
