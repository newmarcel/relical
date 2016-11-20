//
//  NSURL+CachesDirectory.swift
//  Relical
//
//  Created by Marcel Dierkes on 29.06.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation

public extension URL {
    // FIXME: Cache directory url cleanup
    public static var cachesDirectoryURL: URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).last!
        
        let cacheURL = url.appendingPathComponent(Bundle.current.identifier + ".Cache", isDirectory: true)
        do {
            try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            fatalError("Failed to create cache folder \(cacheURL) \(error)")
        }
        return cacheURL
    }
}
