// ChatData.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

enum Topic: String, Codable, CaseIterable, Identifiable {
    case control        = "npg.control"         // 1  — announcements, key exchange
    case pli            = "npg.pli"             // 6  — position/velocity (probably not for chat app)
    case surveillance   = "npg.surveillance"    // 7
    case chat           = "npg.chat"            // 28 — main public P2P chat
    case tactical       = "npg.tactical"        // 29 — group/tactical chat + acks
    case c2             = "npg.c2"              // 100
    case alerts         = "npg.alerts"          // 101
    case logistics      = "npg.logistics"       // 102
    case coord          = "npg.coord"           // 103
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .control:      "Discovery"
        case .pli:          "Position Data"
        case .surveillance: "Surveillance"
        case .chat:         "Public Chat"
        case .tactical:     "Tactical / Group"
        case .c2:           "Command & Control"
        case .alerts:       "Alerts"
        case .logistics:    "Logistics"
        case .coord:        "Coordination"
        }
    }
}

struct Participant: Identifiable, Equatable, Hashable {
    let id: String = UUID().uuidString
    var displayName: String?
    var avatarURL: URL?
    var lastSeen: Date?
    var topics: Set<Topic> = []      // which channels this peer is listening/publishing to
    var isOnline: Bool { Date.now.timeIntervalSince(lastSeen ?? .distantPast) < 300 }
    let firstName: String
    let lastName: String
    let username: String
    let profileImageLink: URL?
    var name: PersonNameComponents {
        PersonNameComponents(
            givenName: self.firstName,
            familyName: self.lastName,
            nickname: self.username
        )
    }
}

struct Conversation: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var participants: [Participant]
    var messages: [Message]
    var updatedAt: Date
    var isRead: Bool
    var isPinned: Bool
    var isGroupChat: Bool = true
    var profileImageLink: String?
    func particpantsNotIncludingCurrentUser() -> [Participant] {
        return participants.filter { $0 != sampleLoggedInUser }
    }
    mutating func append(_ message: Message) {
            messages.append(message)
            updatedAt = message.createdAt
            isRead = (message.author == sampleLoggedInUser) // or your logic
        }
}

struct Message: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var text: String
    var createdAt: Date
    var updatedAt = Date()
    var author: Participant
    var attachments: [Attachment]? = []
    var reactions: [Reaction]? = []
}

struct Attachment: Identifiable, Hashable {
    let id: String
    var width: Int
    var height: Int
    var url: String
    var fileName: String
    var size: Int
    var type: String
    var thumbnails: [Thumbnail]? = []
}

struct Thumbnail: Hashable {
    var width: Int
    var height: Int
    var url: String
}

struct Reaction: Identifiable, Hashable {
    let id: UUID
    var message: Message
    var author: Participant
}

extension Date {
    var daysSinceNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date.now).day ?? 0
    }
}

// Claimed Authors of Zen Crypted Message

let sampleParticipantJohn = Participant(
    firstName: "Ihor",
    lastName: "Horobets",
    username: "iho",
    profileImageLink: nil
)

let sampleParticipantJane = Participant(
    firstName: "Yevgen",
    lastName: "Gadibirov",
    username: "monetapm",
    profileImageLink: nil
)

let sampleParticipantAlex = Participant(
    firstName: "Maksym",
    lastName: "Sokhatskyi",
    username: "5HT",
    profileImageLink: nil
    
)

let sampleLoggedInUser = sampleParticipantJane

let sampleMessageHelloWorldJohn = Message(text: "PING?", createdAt: .now, author: sampleParticipantJohn)
let sampleMessageHelloWorldJane = Message(text: "PONG!", createdAt: .now, author: sampleParticipantJane)

let sampleConversation = Conversation(
    participants: [sampleParticipantJane, sampleParticipantJohn],
    messages: [sampleMessageHelloWorldJohn,sampleMessageHelloWorldJane],
    updatedAt: Date.now,
    isRead: true,
    isPinned: true,
    profileImageLink: nil
)

let sampleLongConversation = Conversation(
    participants: [sampleParticipantJane, sampleParticipantAlex],
    messages: sampleMessages,
    updatedAt: Date.now,
    isRead: true,
    isPinned: true,
    profileImageLink: nil
)

let sampleGroupConversation = Conversation(
    participants: [sampleParticipantJane, sampleParticipantAlex, sampleParticipantJohn],
    messages: sampleGroupMessage,
    updatedAt: Date.now,
    isRead: false,
    isPinned: true,
    profileImageLink: nil
)

let sampleMessages = [
    Message(text: "Hey Jane, what's up?", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "Nothing much, how about you?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "I'm doing great, thanks for asking!", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "No problem, I'm doing great too!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Do you have any plans for this weekend?", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "No, I'm just chilling at home. What about you?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "I don't have any plans either, just wondered what you were up to.", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "Have you seen the new movie?", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "No, I haven't. What's it about?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "It's a great movie! You should watch it.", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "I'll definitely check it out!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "What time is it playing at the local theater?", createdAt: .now, author: sampleParticipantJane),
    Message(text: "It's at 7:00 PM.", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "You want to meet up at the coffee shop, then go check it out", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Great! See you there!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Bye!", createdAt: .now, author: sampleParticipantAlex)
]
let sampleGroupMessage = [
    Message(text: "Hey, where do y'all want to eat at tonight?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "I don't know, I'm just thinking about it.", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Me either, I'm otherwise occupied at the moment.", createdAt: .now, author: sampleParticipantAlex),
    Message(text: "How about the coffee shop?", createdAt: .now, author: sampleParticipantJohn),
    Message(text: "Sounds good to me!", createdAt: .now, author: sampleParticipantJane),
    Message(text: "Sounds good to me too!", createdAt: .now, author: sampleParticipantAlex)
]
