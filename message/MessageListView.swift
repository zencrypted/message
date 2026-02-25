// MessageListView.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct MessageListView: View {
    let messages: [Message]
    let shouldShowParticipantInfo: Bool

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(messages) { message in
                    VStack {
                        formatedDate(message.createdAt)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        MessageBubbleView(message, shouldShowParticipantInfo: shouldShowParticipantInfo)
                    }
                    .padding(.bottom)
                }
            }
            .padding()
        }
        .defaultScrollAnchor(.bottom)
    }

    func formatedDate(_ date: Date) -> some View {
        if date.daysSinceNow < 1 {
            Text("Today \(date.formatted(date: .omitted, time: .shortened))")
        } else if date.daysSinceNow == 1 {
            Text("Yesterday \(date.formatted(date: .omitted, time: .shortened))")
        } else if date.daysSinceNow < 7 {
            Text("\(date.formatted(.dateTime.weekday(.wide))) \(date.formatted(date: .omitted, time: .shortened))")
        } else {
            Text("\(date.formatted(.dateTime.weekday())), \(date.formatted(.dateTime.day().month())) at \(date.formatted(date: .omitted, time: .shortened))")
        }
    }
}

#Preview {
    MessageListView(
        messages: [
            Message(text: "Hello World", createdAt: .now.addingTimeInterval(-86400 * 10), author: sampleParticipantJohn), // 10 days before
            Message(text: "Hello World", createdAt: .now.addingTimeInterval(-86400 * 3), author: sampleParticipantJohn), // 3 days before
            Message(text: "Hello World", createdAt: .now.addingTimeInterval(-86400 * 1), author: sampleParticipantJohn), // yesterday
            sampleMessageHelloWorldJohn, //today
            sampleMessageHelloWorldJane, //today
        ],
        shouldShowParticipantInfo: true
    )
}
