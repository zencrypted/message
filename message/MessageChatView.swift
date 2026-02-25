// MesssageChatView.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct MessageChatView: View {
    let conversation: Conversation
    @State var text = ""
    @State var isShowingAttachmentPicker = false
    @State var attachments: [Attachment] = []
    @Namespace var attachmentPickerAnimation
    let matchingGeometryID = "attachments"
    @State var photoSelectorVM = PhotoSelectorViewModel()

    var body: some View {
        VStack {
            MessageListView(
                messages: conversation.messages,
                shouldShowParticipantInfo: conversation.participants.count > 2
            )
            MessageComposerView(
                messageText: $text,
                isShowingAttachmentPicker: $isShowingAttachmentPicker,
                matchingGeometryID: matchingGeometryID,
                attachmentPickerAnimation: attachmentPickerAnimation,
                attachments: $attachments,
                photoSelectorVM: photoSelectorVM
            )
            .padding([.horizontal, .bottom])
        }
        .overlay {
            if isShowingAttachmentPicker {
                AddAttachmentsView(
                    isPresented: $isShowingAttachmentPicker,
                    matchingGeometryID: matchingGeometryID,
                    attachmentPickerAnimation: attachmentPickerAnimation,
                    photoSelectorVM: photoSelectorVM
                )
            }
        }
    }
}

#Preview {
    MessageChatView(conversation: sampleLongConversation)
}
