//
//  DiskCache.swift
//  Relical
//
//  Created by Marcel Dierkes on 01.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation

/// A filesystem-based persistent cache that
/// uses an internal convenience in-memory cache
/// for fast access times.
public final class DiskCache {
    
    // MARK: - Properties
    
    fileprivate let backingCache: NSCache<AnyObject, AnyObject>
    fileprivate let queue: DispatchQueue
    
    /// The cache directory URL
    public let url: URL
    
    /// The designated initializer.
    ///
    /// - Parameter url: A cache directory URL, defaults to an internal
    ///                  folder inside the system/app's cache directory
    public required init(url: URL = URL.cachesDirectoryURL.appendingPathComponent("Default")) {
        self.backingCache = NSCache()
        self.queue = DispatchQueue(
            label: "\(Bundle.current.identifier).DiskCacheQueue",
            attributes: []
        )
        self.url = url
        self.createCacheDirectory(at: url)
    }
    
    // MARK: - Life Cycle
    
    /// Convenience initializer that creates a custom cache
    /// directory inside the system/app's cache directory.
    ///
    /// - Parameter cacheName: The cache name used as parent folder.
    public convenience init(cacheName: String) {
        let url = URL.cachesDirectoryURL.appendingPathComponent(cacheName)
        self.init(url: url)
    }
    
    // MARK: -
    
    /// Clears the temporary in-memory backing cache. All requested
    /// cache items will be loaded from disk after this method is
    /// called.
    ///
    /// - Parameter completion: A completion handler
    public func purgeMemory(_ completion: @escaping () -> Void) {
        self.queue.async {
            self.backingCache.removeAllObjects()
            DispatchQueue.main.async(execute: completion)
        }
    }
    
    private func createCacheDirectory(at url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            fatalError("Failed to create cache folder at \(url) \(error)")
        }
    }
}

fileprivate let filePrefix = "Cache"
fileprivate let fileSuffix = "tmp"

fileprivate extension DiskCache {
    func fileURL(forKey key: String) -> URL {
        let key = "\(filePrefix)\(key.hashValue)"
        return self.url
            .appendingPathComponent(key, isDirectory: false)
            .appendingPathExtension(fileSuffix)
    }
    
    
    func filePath(forKey key: String) -> String {
        let path: String! = self.fileURL(forKey: key).path
        return path
    }
    
    func persist<Value: NSCoding>(value: Value, forKey key: String) -> Bool {
        let path = self.filePath(forKey: key)
        let item = CacheItem(value: value)
        return NSKeyedArchiver.archiveRootObject(item, toFile: path)
    }
    
    
    func retrieveValue<Value: NSCoding>(forKey key: String) -> Value? {
        let path = self.filePath(forKey: key)
        guard let item = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? CacheItem<Value>, !item.isExpired else {
            return nil
        }
        return item.value
    }
    
    
    func removeValue(forKey key: String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: self.fileURL(forKey: key))
            return true
        } catch let error {
            print("Failed to delete cache object \(key) \(error)")
            return false
        }
    }
    
    func removeAllValues() -> Bool {
        let fileManager = FileManager.default
        let tmpURL = self.url.appendingPathExtension("tmp")
        let directoryExists = fileManager.fileExists(atPath: self.url.path)
        
        do {
            if directoryExists {
                try fileManager.moveItem(at: self.url, to: tmpURL)
                try fileManager.createDirectory(at: self.url, withIntermediateDirectories: true)
                try fileManager.removeItem(at: tmpURL)
            } else {
                try fileManager.createDirectory(at: self.url, withIntermediateDirectories: true)
            }
            return true
        } catch let error {
            print("Failed to reset cache directory \(error)")
            return false
        }
    }
}

// MARK: - DiskCache + AsynchronousCache
extension DiskCache: AsynchronousCache {
    public func set<Value: NSCoding>(value: Value, forKey key: String, expirationDate: Date? = nil, completion: CacheCompletionHandler? = nil) {
        self.queue.async {
            let object = CacheItem(value: value, expirationDate: expirationDate)
            
            // Persist on disk
            let isWrittenToDisk = self.persist(value: value, forKey: key)
            if isWrittenToDisk {
                // Store the object in-memory
                self.backingCache.setObject(object, forKey: key as NSString)
            }
            
            completion?(isWrittenToDisk)
        }
    }
    
    public func value<Value: NSCoding>(forKey key: String, completion: @escaping (_ value: Value?) -> Void) {
        self.queue.async {
            // Check in-memory for the object
            if let object = self.backingCache.object(forKey: key as AnyObject) as? CacheItem<Value> {
                let value: Value? = object.isExpired ? nil : object.value
                completion(value)
                return
            }
            
            // Load from disk if not in memory
            completion(self.retrieveValue(forKey: key))
        }
    }
    
    public func removeValue(forKey key: String, completion: CacheCompletionHandler? = nil) {
        self.queue.async {
            // Remove in-memory object
            self.backingCache.removeObject(forKey: key as AnyObject)
            
            // Remove from disk
            completion?(self.removeValue(forKey: key))
        }
    }
    
    public func removeAllValues(completion: CacheCompletionHandler? = nil) {
        self.queue.async {
            // Remove in-memory cache
            self.backingCache.removeAllObjects()
            
            // Remove from disk
            completion?(self.removeAllValues())
        }
    }
}
