// MessageComposerView.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct MessageComposerView: View {
    @Binding var messageText: String
    @Binding var isShowingAttachmentPicker: Bool
    let matchingGeometryID: String
    let attachmentPickerAnimation: Namespace.ID
    @Binding var attachments: [Attachment]
    @Bindable var photoSelectorVM: PhotoSelectorViewModel
    @State private var text = "\u{200B}"
    
    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isShowingAttachmentPicker.toggle()
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    //.symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .imageScale(.large)
                    .symbolEffect(.pulse, options: .repeating)
            }
            .buttonStyle(.plain)
            .contentMargins(.horizontal, 4)
            .foregroundStyle(.tint, .secondary)
            .matchedGeometryEffect(id: matchingGeometryID, in: attachmentPickerAnimation, isSource: true)

            VStack(spacing: 0) {
                if !photoSelectorVM.images.isEmpty {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.fixed(100))]) {
                            ForEach(0..<photoSelectorVM.images.count, id: \.self) { index in
                                if !photoSelectorVM.images.isEmpty {
                                    Image(platformImage: photoSelectorVM.images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                photoSelectorVM.images.remove(at: index)
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .foregroundStyle(.white)
                                                    .padding(4)
                                                    .background(.secondary)
                                                    .clipShape(Circle())
                                            }.buttonStyle(.plain)
                                        }
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                    .padding(.vertical, 4)
                    .contentMargins(4, for: .scrollContent)
                    .overlay {
                        Rectangle()
                            .fill(.clear)
                            .roundedCornerWithBorder(borderColor: .secondary, radius: 8, corners: [.topLeft, .topRight])
                    }
                }
                TextField("Message...", text: $text,
                          prompt: Text("Use Option+ENTER to add lines...").foregroundStyle(.secondary), axis: .vertical)
                    .lineLimit(1...7)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .contentMargins(.horizontal, 4)
                    .onAppear { text = text }
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                        }
                    .multilineTextAlignment(.leading)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 1))
            }
            if messageText.isEmpty {
                EmptyView()
            } else {
                Button {
                    // send message
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var attachmentPickerAnimation
    MessageComposerView(
        messageText: .constant(""),
        isShowingAttachmentPicker: .constant(false),
        matchingGeometryID: "attachments",
        attachmentPickerAnimation: attachmentPickerAnimation,
        attachments: .constant([]),
        photoSelectorVM: PhotoSelectorViewModel()
    )
}
