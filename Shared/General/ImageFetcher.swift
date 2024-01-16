//
//  ImageFetcher.swift
//  Meikade
//
//  Created by Armin on 1/16/24.
//

import Foundation

struct ImageFetcher {
    
    enum ImageFetcherError: Error {
        case imageDataCorrupted
    }
    
    /// The path where the cached image located
    private static var cachePath: URL {
        URL.cachesDirectory.appending(path: "muzei.jpg")
    }
    
    /// The cached image
    static var cachedImage: UXImage? {
        guard let imageData = try? Data(contentsOf: cachePath) else {
            return nil
        }
        return UXImage(data: imageData)
    }
    
    /// Is cached image currently available
    static var cachedImageAvailable: Bool {
        cachedImage != nil
    }
    
    /// Download and cache the image
    static func fetchImage(_ address: String) async throws -> UXImage? {
        // Download image from URL
        guard let url = URL(string: address) else { return nil }
        let (imageData, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UXImage(data: imageData) else {
            throw ImageFetcherError.imageDataCorrupted
        }
        
        // Spawn another task to cache the downloaded image
        Task {
            try? await cache(imageData)
        }
        
        return image
    }
    
    /// Save the image locally
    private static func cache(_ imageData: Data) async throws {
        try imageData.write(to: cachePath)
    }
}
