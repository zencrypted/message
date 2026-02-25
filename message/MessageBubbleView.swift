// MessageBubbleView.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let shouldShowParticipantInfo: Bool
    init(_ message: Message, shouldShowParticipantInfo: Bool) {
        self.message = message
        self.shouldShowParticipantInfo = shouldShowParticipantInfo
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if sampleLoggedInUser == message.author {
                Spacer()
            }

            if shouldShowParticipantInfo && sampleLoggedInUser != message.author {
                ChatAvatarView(participant: message.author)
            }

            VStack(alignment: .leading, spacing: 4) {
                if shouldShowParticipantInfo && sampleLoggedInUser != message.author {
                    Text(message.author.name, format: .name(style: .medium))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                }
                Text(message.text)
                    .messageBubbleStyle(isFromYou: sampleLoggedInUser == message.author)
            }

            if sampleLoggedInUser != message.author {
                Spacer()
            }
        }
    }
}

#Preview {
    VStack {
        MessageBubbleView(sampleMessageHelloWorldJohn, shouldShowParticipantInfo: true)
        MessageBubbleView(sampleMessageHelloWorldJane, shouldShowParticipantInfo: true)
        MessageBubbleView(sampleMessageHelloWorldJane, shouldShowParticipantInfo: false)
        MessageBubbleView(sampleMessageHelloWorldJane, shouldShowParticipantInfo: false)
    }
}
