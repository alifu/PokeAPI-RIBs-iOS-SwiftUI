//
//  ImagePipeline+Extension.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import Nuke

// Create a shared pipeline with disk cache
extension ImagePipeline {
    static let cached = ImagePipeline {
        let dataCache = try? DataCache(name: "com.example.app.datacache")
        dataCache?.sizeLimit = 200 * 1024 * 1024 // 200 MB
        $0.dataCache = dataCache
        $0.imageCache = ImageCache.shared
    }
}
