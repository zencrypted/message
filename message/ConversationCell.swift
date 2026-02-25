// ConversationCell.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct ConversationCell: View {
    let conversation: Conversation
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        HStack {
            if dynamicTypeSize >= .accessibility1 {
                EmptyView()
            } else {
                Circle()
                    .fill(conversation.isRead ? .clear : .blue)
                    .frame(width: 10, height: 10)

                ChatAvatarView(participant: conversation.particpantsNotIncludingCurrentUser().first!, size: 50)
            }

            if dynamicTypeSize >= .accessibility1 {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        if !conversation.isRead {
                            Circle()
                                .fill(.blue)
                                .frame(width: 20, height: 20)
                        }

                        formatConversationName()
                            .font(.headline)
                            .lineLimit(2)
                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }

                    Text(conversation.messages.last!.text)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundStyle(.secondary)

                    formattedDate()
                }
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        formatConversationName()
                            .font(.headline)
                            .lineLimit(1)
                        Spacer()

                        HStack {
                            formattedDate()
                            Image(systemName: "chevron.right")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }

                    Text(conversation.messages.last!.text)
                        .font(.subheadline)
                        .lineLimit(2, reservesSpace: true)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    func formattedDate() -> Text {
        if conversation.updatedAt.daysSinceNow < 1 {
            return Text(conversation.updatedAt.formatted(date: .omitted, time: .shortened))
        } else if conversation.updatedAt.daysSinceNow < 7 {
            return Text(conversation.updatedAt.formatted(.dateTime.weekday(.wide)))
        }
        return Text(conversation.updatedAt.formatted(date: .numeric, time: .omitted))
    }

    func formatConversationName() -> Text {
        let firstNames = conversation.particpantsNotIncludingCurrentUser().map { $0.firstName }
        let allButLast = firstNames.dropLast()
        let last = firstNames.last!
        if conversation.particpantsNotIncludingCurrentUser().count == 1 {
            return Text(conversation.particpantsNotIncludingCurrentUser().first!.name, format: .name(style: .medium))
        } else if conversation.particpantsNotIncludingCurrentUser().count == 2 {
            return Text(firstNames.joined(separator: " & "))
        } else {
            return Text(allButLast.joined(separator: ", ") + ", & " + last)
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        // with todays date
        ConversationCell(
            conversation: Conversation(
                participants: [sampleParticipantJohn, sampleParticipantJane],
                messages: [sampleMessageHelloWorldJohn, sampleMessageHelloWorldJane, sampleMessageHelloWorldJohn],
                updatedAt: Date.now,
                isRead: false,
                isPinned: true,
                profileImageLink: nil
            )
        )
        // with a long time ago date
        ConversationCell(
            conversation: Conversation(
                participants: [sampleParticipantJohn, sampleParticipantJane],
                messages: [sampleMessageHelloWorldJohn, sampleMessageHelloWorldJane, sampleMessageHelloWorldJohn],
                updatedAt: Date.now.addingTimeInterval(-86400 * 2),
                isRead: false,
                isPinned: true,
                profileImageLink: nil
            )
        )
        // with a long time ago date
        ConversationCell(
            conversation: Conversation(
                participants: [sampleParticipantJohn, sampleParticipantJane],
                messages: [sampleMessageHelloWorldJohn, sampleMessageHelloWorldJane, sampleMessageHelloWorldJohn],
                updatedAt: Date.now.addingTimeInterval(-86400 * 10),
                isRead: false,
                isPinned: true,
                profileImageLink: nil
            )
        )
        // with a long message
        ConversationCell(
            conversation: Conversation(
                participants: [sampleParticipantJohn, sampleParticipantJane],
                messages: [Message(text: "Whats up with your face? It look's really weird and I don't know if you have noticied it yet.", createdAt: .now, author: sampleParticipantJohn)],
                updatedAt: Date.now.addingTimeInterval(-86400 * 10),
                isRead: false,
                isPinned: true,
                profileImageLink: nil
            )
        )
    }
}
