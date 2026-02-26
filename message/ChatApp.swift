// ChatApp.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI
import CoreData

@main
struct ChatApp: App {
    let persistenceController = PersistenceController.shared
    @State var selectedConversation: Conversation?

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                ConversationListView(
                    conversations: [
                        sampleConversation,
                        sampleLongConversation,
                        sampleGroupConversation
                    ],
                    selectedConversation: $selectedConversation
                )
            } detail: {
                if let selectedConversation {
                    MessageChatView(conversation: selectedConversation)
                } else {
                    ContentUnavailableView("Select a conversation", systemImage: "exclamationmark.bubble")
                }
            }
        }
    }
}
