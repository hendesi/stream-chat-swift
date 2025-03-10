//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamChat

/// This class allows you to wrap an existing `DatabaseSession` and adjust the behavior of its methods.
class DatabaseSession_Mock: DatabaseSession {
    /// The wrapped session
    let underlyingSession: DatabaseSession

    /// If set to a non-nil value, the error is returned from all throwing methods of the session
    @Atomic var errorToReturn: Error?

    init(underlyingSession: DatabaseSession) {
        self.underlyingSession = underlyingSession
    }

    var markChannelAsReadParams: (cid: ChannelId, userId: UserId, at: Date)?
    var markChannelAsUnreadParams: (cid: ChannelId, userId: UserId)?

    func addReaction(
        to messageId: MessageId,
        type: MessageReactionType,
        score: Int,
        enforceUnique: Bool,
        extraData: [String: RawJSON],
        localState: LocalReactionState?
    ) throws -> MessageReactionDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.addReaction(
            to: messageId,
            type: type,
            score: score,
            enforceUnique: enforceUnique,
            extraData: extraData,
            localState: localState
        )
    }

    func removeReaction(from messageId: MessageId, type: MessageReactionType, on version: String?) throws -> MessageReactionDTO? {
        try throwErrorIfNeeded()
        return try underlyingSession.removeReaction(from: messageId, type: type, on: version)
    }

    func saveCurrentDevice(_ deviceId: String) throws {
        try throwErrorIfNeeded()
        return try saveCurrentDevice(deviceId)
    }

    func saveCurrentUserDevices(_ devices: [DevicePayload], clearExisting: Bool) throws -> [DeviceDTO] {
        try throwErrorIfNeeded()
        return try underlyingSession.saveCurrentUserDevices(devices, clearExisting: clearExisting)
    }

    func saveChannelList(payload: ChannelListPayload, query: ChannelListQuery?) -> [ChannelDTO] {
        return underlyingSession.saveChannelList(payload: payload, query: query)
    }

    func saveQuery(query: ReactionListQuery) throws -> ReactionListQueryDTO? {
        return try underlyingSession.saveQuery(query: query)
    }

    func saveChannel(
        payload: ChannelDetailPayload,
        query: ChannelListQuery?,
        cache: PreWarmedCache?
    ) throws -> ChannelDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveChannel(payload: payload, query: query, cache: cache)
    }

    func saveUser(payload: UserPayload, query: UserListQuery?, cache: PreWarmedCache?) throws -> UserDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveUser(payload: payload, query: query, cache: cache)
    }

    func saveUsers(payload: UserListPayload, query: UserListQuery?) -> [UserDTO] {
        return underlyingSession.saveUsers(payload: payload, query: query)
    }

    func saveQuery(query: UserListQuery) throws -> UserListQueryDTO? {
        try throwErrorIfNeeded()
        return try underlyingSession.saveQuery(query: query)
    }

    func userListQuery(filterHash: String) -> UserListQueryDTO? {
        underlyingSession.userListQuery(filterHash: filterHash)
    }

    func user(id: UserId) -> UserDTO? {
        underlyingSession.user(id: id)
    }

    func deleteQuery(_ query: UserListQuery) {
        underlyingSession.deleteQuery(query)
    }

    func cleanChannels(cids: Set<ChannelId>) {
        underlyingSession.cleanChannels(cids: cids)
    }

    func removeChannels(cids: Set<ChannelId>) {
        underlyingSession.removeChannels(cids: cids)
    }

    func saveCurrentUser(payload: CurrentUserPayload) throws -> CurrentUserDTO {
        try throwErrorIfNeeded()
        return try saveCurrentUser(payload: payload)
    }

    func saveCurrentUserUnreadCount(count: UnreadCount) throws {
        try throwErrorIfNeeded()
        try saveCurrentUserUnreadCount(count: count)
    }

    func deleteDevice(id: DeviceId) {
        underlyingSession.deleteDevice(id: id)
    }

    var currentUser: CurrentUserDTO? { underlyingSession.currentUser }

    func createNewMessage(
        in cid: ChannelId,
        messageId: MessageId?,
        text: String,
        pinning: MessagePinning?,
        command: String?,
        arguments: String?,
        parentMessageId: MessageId?,
        attachments: [AnyAttachmentPayload],
        mentionedUserIds: [UserId],
        showReplyInChannel: Bool,
        isSilent: Bool,
        quotedMessageId: MessageId?,
        createdAt: Date?,
        skipPush: Bool,
        skipEnrichUrl: Bool,
        extraData: [String: RawJSON]
    ) throws -> MessageDTO {
        try throwErrorIfNeeded()

        return try underlyingSession.createNewMessage(
            in: cid,
            messageId: messageId,
            text: text,
            pinning: pinning,
            command: command,
            arguments: arguments,
            parentMessageId: parentMessageId,
            attachments: attachments,
            mentionedUserIds: mentionedUserIds,
            showReplyInChannel: showReplyInChannel,
            isSilent: isSilent,
            quotedMessageId: quotedMessageId,
            createdAt: createdAt,
            skipPush: skipPush,
            skipEnrichUrl: skipEnrichUrl,
            extraData: extraData
        )
    }

    func saveMessage(
        payload: MessagePayload,
        for cid: ChannelId?,
        syncOwnReactions: Bool,
        cache: PreWarmedCache?
    ) throws -> MessageDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveMessage(payload: payload, for: cid, syncOwnReactions: syncOwnReactions, cache: cache)
    }

    func saveMessage(payload: MessagePayload, channelDTO: ChannelDTO, syncOwnReactions: Bool, cache: PreWarmedCache?) throws -> MessageDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveMessage(payload: payload, channelDTO: channelDTO, syncOwnReactions: syncOwnReactions, cache: cache)
    }

    func saveMessages(messagesPayload: MessageListPayload, for cid: ChannelId?, syncOwnReactions: Bool) -> [MessageDTO] {
        return underlyingSession.saveMessages(messagesPayload: messagesPayload, for: cid, syncOwnReactions: syncOwnReactions)
    }

    func saveMessageSearch(payload: MessageSearchResultsPayload, for query: MessageSearchQuery) -> [MessageDTO] {
        return underlyingSession.saveMessageSearch(payload: payload, for: query)
    }

    func pin(message: MessageDTO, pinning: MessagePinning) throws {
        try throwErrorIfNeeded()
        return try underlyingSession.pin(message: message, pinning: pinning)
    }

    func unpin(message: MessageDTO) {
        underlyingSession.unpin(message: message)
    }

    func message(id: MessageId) -> MessageDTO? {
        underlyingSession.message(id: id)
    }

    func messageExists(id: MessageId) -> Bool {
        underlyingSession.messageExists(id: id)
    }

    func delete(message: MessageDTO) {
        underlyingSession.delete(message: message)
    }

    func preview(for cid: ChannelId) -> MessageDTO? {
        underlyingSession.preview(for: cid)
    }

    func rescueMessagesStuckInSending() {
        underlyingSession.rescueMessagesStuckInSending()
    }

    func reaction(messageId: MessageId, userId: UserId, type: MessageReactionType) -> MessageReactionDTO? {
        underlyingSession.reaction(messageId: messageId, userId: userId, type: type)
    }

    func saveReaction(payload: MessageReactionPayload, query: ReactionListQuery?, cache: PreWarmedCache?) throws -> MessageReactionDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveReaction(payload: payload, query: query, cache: cache)
    }

    func saveReactions(payload: MessageReactionsPayload, query: ReactionListQuery?) -> [MessageReactionDTO] {
        return underlyingSession.saveReactions(payload: payload, query: query)
    }

    func delete(reaction: MessageReactionDTO) {
        underlyingSession.delete(reaction: reaction)
    }

    func saveChannelRead(payload: ChannelReadPayload, for cid: ChannelId, cache: PreWarmedCache?) throws -> ChannelReadDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveChannelRead(payload: payload, for: cid, cache: cache)
    }

    func markChannelAsRead(cid: ChannelId, userId: UserId, at: Date) {
        markChannelAsReadParams = (cid, userId, at)
        underlyingSession.markChannelAsRead(cid: cid, userId: userId, at: at)
    }

    func markChannelAsUnread(cid: ChannelId, by userId: UserId) {
        markChannelAsUnreadParams = (cid, userId)
        underlyingSession.markChannelAsUnread(cid: cid, by: userId)
    }
    
    func markChannelAsUnread(for cid: ChannelId, userId: UserId, from messageId: MessageId, lastReadMessageId: MessageId?, lastReadAt: Date?, unreadMessagesCount: Int?) {
        underlyingSession.markChannelAsUnread(
            for: cid,
            userId: userId,
            from: messageId,
            lastReadMessageId: lastReadMessageId,
            lastReadAt: lastReadAt,
            unreadMessagesCount: unreadMessagesCount
        )
    }

    func loadChannelRead(cid: ChannelId, userId: String) -> ChannelReadDTO? {
        underlyingSession.loadChannelRead(cid: cid, userId: userId)
    }

    func loadChannelReads(for userId: UserId) -> [ChannelReadDTO] {
        underlyingSession.loadChannelReads(for: userId)
    }

    func saveQuery(query: ChannelListQuery) -> ChannelListQueryDTO {
        underlyingSession.saveQuery(query: query)
    }

    func channelListQuery(filterHash: String) -> ChannelListQueryDTO? {
        underlyingSession.channelListQuery(filterHash: filterHash)
    }

    func loadAllChannelListQueries() -> [ChannelListQueryDTO] {
        underlyingSession.loadAllChannelListQueries()
    }
    
    func saveChannel(
        payload: ChannelPayload,
        query: ChannelListQuery?,
        cache: PreWarmedCache?
    ) throws -> ChannelDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveChannel(payload: payload, query: query, cache: cache)
    }
    
    func channel(cid: ChannelId) -> ChannelDTO? {
        underlyingSession.channel(cid: cid)
    }

    func saveMember(
        payload: MemberPayload,
        channelId: ChannelId,
        query: ChannelMemberListQuery?,
        cache: PreWarmedCache?
    ) throws -> MemberDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveMember(payload: payload, channelId: channelId, query: query, cache: cache)
    }

    func saveMembers(payload: ChannelMemberListPayload, channelId: ChannelId, query: ChannelMemberListQuery?) -> [MemberDTO] {
        return underlyingSession.saveMembers(payload: payload, channelId: channelId, query: query)
    }

    func member(userId: UserId, cid: ChannelId) -> MemberDTO? {
        underlyingSession.member(userId: userId, cid: cid)
    }

    func channelMemberListQuery(queryHash: String) -> ChannelMemberListQueryDTO? {
        underlyingSession.channelMemberListQuery(queryHash: queryHash)
    }

    func saveQuery(_ query: ChannelMemberListQuery) throws -> ChannelMemberListQueryDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveQuery(query)
    }

    func attachment(id: AttachmentId) -> AttachmentDTO? {
        underlyingSession.attachment(id: id)
    }

    func saveAttachment(payload: MessageAttachmentPayload, id: AttachmentId) throws -> AttachmentDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveAttachment(payload: payload, id: id)
    }

    func createNewAttachment(attachment: AnyAttachmentPayload, id: AttachmentId) throws -> AttachmentDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.createNewAttachment(attachment: attachment, id: id)
    }

    func delete(attachment: AttachmentDTO) {
        underlyingSession.delete(attachment: attachment)
    }

    func saveChannelMute(
        payload: MutedChannelPayload
    ) throws -> ChannelMuteDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveChannelMute(payload: payload)
    }

    func delete(query: ChannelListQuery) {
        underlyingSession.delete(query: query)
    }

    func saveMessage(payload: MessagePayload, for query: MessageSearchQuery, cache: PreWarmedCache?) throws -> MessageDTO {
        try throwErrorIfNeeded()
        return try underlyingSession.saveMessage(payload: payload, for: query, cache: cache)
    }

    func deleteQuery(_ query: MessageSearchQuery) {
        underlyingSession.deleteQuery(query)
    }

    func saveQuery(query: MessageSearchQuery) -> MessageSearchQueryDTO {
        underlyingSession.saveQuery(query: query)
    }

    func deleteQueuedRequest(id: String) {
        underlyingSession.deleteQueuedRequest(id: id)
    }

    func loadOrCreateChannelRead(
        cid: StreamChat.ChannelId,
        userId: StreamChat.UserId
    ) -> StreamChat.ChannelReadDTO? {
        underlyingSession.loadChannelRead(cid: cid, userId: userId)
    }

    func saveThreadList(payload: ThreadListPayload, query: ThreadListQuery?) -> [ThreadDTO] {
        underlyingSession.saveThreadList(payload: payload, query: query)
    }

    func saveThreadParticipant(payload: ThreadParticipantPayload, threadId: String, cache: PreWarmedCache?) throws -> ThreadParticipantDTO {
        try underlyingSession.saveThreadParticipant(payload: payload, threadId: threadId, cache: cache)
    }

    func saveThread(payload: ThreadPayload, query: ThreadListQuery?, cache: PreWarmedCache?) throws -> ThreadDTO {
        try underlyingSession.saveThread(payload: payload, query: query, cache: cache)
    }

    func saveThreadRead(payload: ThreadReadPayload, parentMessageId: String, cache: PreWarmedCache?) throws -> ThreadReadDTO {
        try underlyingSession.saveThreadRead(payload: payload, parentMessageId: parentMessageId, cache: cache)
    }
}

private extension DatabaseSession_Mock {
    func throwErrorIfNeeded() throws {
        guard let error = errorToReturn else { return }
        throw error
    }
}
