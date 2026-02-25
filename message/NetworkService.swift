// MessageService.swift
// Copyright (c) 2026 Namdak Tonpa

import Foundation

@MainActor @Observable
final class MessageService {
    static let shared = MessageService()
    
    private(set) var peerManager: MessagePeer?
    private(set) var groupManager: MessageGroup?
    
    var peers: [Participant] = []
    var conversations: [Conversation] = []
    
    private init() {}
    
    func start() {
        peerManager = MessagePeer(service: self)
        groupManager = MessageGroup(service: self)
        Task { await peerManager?.startListening() }
        Task { await groupManager?.startListening() }
    }
    
    func appendMessage(_ message: Message, to conversationId: String) {
        if let index = conversations.firstIndex(where: { $0.id == conversationId }) {
            conversations[index].append(message)   // ← clean!
        }
        else {
            let newConv = Conversation(participants: [message.author], messages: [message],
                updatedAt: message.createdAt, isRead: true, isPinned: false, profileImageLink: nil)
            conversations.append(newConv)
            conversations.sort { $0.updatedAt > $1.updatedAt }
        }
    }
    
    func sendText(_ text: String, to conversation: Conversation) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let now = Date()
        let outgoingMessage = Message(
            text: trimmed,
            createdAt: now,
            author: sampleLoggedInUser
        )
        
        // 1. Optimistic UI update (immediate feedback)
        appendMessage(outgoingMessage, to: conversation.id)
        
        // 2. Actually send in background
        do {
            if conversation.isGroupChat { // ← you need reliable way to detect group vs 1:1
                await groupManager?.send(trimmed, in: conversation)
            } else {
                await peerManager?.send(trimmed, to: conversation)
            }
        }
    }
}
