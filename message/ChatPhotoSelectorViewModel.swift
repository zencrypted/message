// ChatPhotoSelectorViewModel.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

// Platform-specific image type
#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

extension Image {
    init(platformImage: PlatformImage) {
        #if canImport(UIKit)
        self.init(uiImage: platformImage)
        #elseif canImport(AppKit)
        self.init(nsImage: platformImage)
        #endif
    }
}

@Observable
class PhotoSelectorViewModel {
    var images: [PlatformImage] = []
    // Add a single image from Data (cross-platform)
    @MainActor
    func addImage(from data: Data) {
        if let image = PlatformImage(data: data) {
            images.append(image)
        }
    }
    // Add multiple images from Data
    @MainActor
    func addImages(from datas: [Data]) {
        let newImages = datas.compactMap { PlatformImage(data: $0) }
        images.append(contentsOf: newImages)
    }
    // Clear all
    @MainActor
    func clear() {
        images.removeAll()
    }
}
