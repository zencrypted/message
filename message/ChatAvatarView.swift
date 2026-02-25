// ChatAvatarView.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct ChatAvatarView: View {
    let participant: Participant
    let size: Double

    init(participant: Participant, size: Double = 40) {
        self.participant = participant
        self.size = size
    }

    var body: some View {
        Group {
            if let url = participant.profileImageLink {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        // Displays the loaded image.
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        // Indicates an error.
                        fallbackToInitials()
                    } else {
                        // Acts as a placeholder.
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(.white)
                            .foregroundStyle(.gray.gradient.opacity(0.5))
                    }
                }
            } else {
                fallbackToInitials()
            }
        }
        .frame(width: size, height: size)
        .background(Color.secondary.gradient)
        .clipShape(Circle())
    }

    @ViewBuilder
    func fallbackToInitials() -> some View {
        Text(participant.name, format: .name(style: .abbreviated))
            .font(.title2)
            .minimumScaleFactor(0.05)
            .foregroundStyle(.white)
            .padding(2)
    }
}

#Preview {
    VStack {
        ChatAvatarView(participant: sampleParticipantJohn)
        ChatAvatarView(
            participant: Participant(
                firstName: "Mary",
                lastName: "Jane",
                username: "username_for_Mary",
                profileImageLink: URL(string: "https://tonpa.guru/5HT.jpg")
            ),
            size: 75
        )
        ChatAvatarView(
            participant: Participant(
                firstName: "Aqua",
                lastName: "Man",
                username: "large_avatar_for_AquaMan",
                profileImageLink: URL(string: "https://tonpa.guru/maxim.png")
            ),
            size: 100
        )
    }
}
