// MessageAddAttachmentView.swift
// Copyright (c) 2026 Namdak Tonpa

import PhotosUI
import SwiftUI

struct AddAttachmentsView: View {
    @Binding var isPresented: Bool
    let matchingGeometryID: String
    let attachmentPickerAnimation: Namespace.ID
    @Bindable var photoSelectorVM: PhotoSelectorViewModel
    @State var isShowingPhotosPicker = false
    let maxPhotosToSelect = 10

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(.clear)
                .edgesIgnoringSafeArea(.all)
                .matchedGeometryEffect(id: matchingGeometryID, in: attachmentPickerAnimation, isSource: false)
            VStack(alignment: .leading, spacing: 30) {
            }
            .font(.title)
            .padding(.leading, 40)
            .padding(.bottom, 84)
        }
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation {
                isPresented.toggle()
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var attachmentPickerAnimation

    ZStack {
        VStack {
            Text("Preview")
            Rectangle().fill(.blue).frame(width: 100, height: 100)
                .padding(100)
            Rectangle().fill(.secondary).frame(width: 100, height: 100)
        }
        AddAttachmentsView(
            isPresented: .constant(true),
            matchingGeometryID: "attachments",
            attachmentPickerAnimation: attachmentPickerAnimation,
            photoSelectorVM: PhotoSelectorViewModel()
        )
    }
}

