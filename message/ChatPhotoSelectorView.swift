// ChatPhotoSelectorView.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI
internal import UniformTypeIdentifiers
#if os(iOS)
import PhotosUI
#endif

struct PhotoSelectorView: View {
    @State private var viewModel = PhotoSelectorViewModel()

    #if os(iOS)
    @State private var selectedItems: [PhotosPickerItem] = []
    #endif

    #if os(macOS)
    @State private var showingFileImporter = false
    #endif

    var body: some View {
        VStack {
            // Picker (platform-specific)
            #if os(iOS)
            PhotosPicker("Select Photos", selection: $selectedItems, matching: .images)
                .onChange(of: selectedItems) {
                    Task {
                        let datas = await loadDatas(from: selectedItems)
                        viewModel.addImages(from: datas)
                    }
                }
            #elseif os(macOS)
            Button("Select Images from Files") {
                showingFileImporter = true
            }
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: [.image],
                allowsMultipleSelection: true
            ) { result in
                Task {
                    if case .success(let urls) = result {
                        let datas = urls.compactMap { try? Data(contentsOf: $0) }
                        viewModel.addImages(from: datas)
                    }
                }
            }
            #else
            Text("Photo selection not supported on this platform")
            #endif
            // Display selected images (cross-platform)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.images, id: \.self) { image in
                    Image(platformImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipped()
                }
            }
            Button("Clear") {
                viewModel.clear()
            }
        }
        .padding()
    }

    #if os(iOS)
    private func loadDatas(from items: [PhotosPickerItem]) async -> [Data] {
        var datas: [Data] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                datas.append(data)
            }
        }
        return datas
    }
    #endif
}
