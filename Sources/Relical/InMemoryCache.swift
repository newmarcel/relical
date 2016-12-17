//
//  InMemoryCache.swift
//  Relical
//
//  Created by Marcel Dierkes on 01.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation

/// A transient in-memory cache that is based
/// on `Foundation.NSCache`.
public final class InMemoryCache {
    
    // MARK: - Properties
    fileprivate let backingCache: NSCache<NSString, AnyObject>
    fileprivate let queue: DispatchQueue
    
    /// The designated initializer.
    public required init() {
        self.backingCache = NSCache()
        self.queue = DispatchQueue(
            label: "\(Bundle.current.identifier).\(String(describing: InMemoryCache.self))Queue",
            attributes: []
        )
    }
}

// MARK: - InMemoryCache + AsynchronousCache
extension InMemoryCache: AsynchronousCache {
    public func set<Value: NSCoding>(value: Value, forKey key: String, expirationDate: Date?, completion: CacheCompletionHandler? = nil) {
        self.queue.async {
            let object = CacheItem(value: value, expirationDate: expirationDate)
            self.backingCache.setObject(object, forKey: key as NSString)
            completion?(true)
        }
    }
    
    public func value<Value: NSCoding>(forKey key: String, completion: @escaping (_ value: Value?) -> Void) {
        self.queue.async {
            let value: Value?
            if let object = self.backingCache.object(forKey: key as NSString) as? CacheItem<Value> {
                value = object.isExpired ? nil : object.value
            } else {
                value = nil
            }
            completion(value)
        }
    }
    
    public func removeValue(forKey key: String, completion: CacheCompletionHandler? = nil) {
        self.queue.async {
            let result = self.backingCache.object(forKey: key as NSString) != nil
            self.backingCache.removeObject(forKey: key as NSString)
            completion?(result)
        }
    }
    
    public func removeAllValues(completion: CacheCompletionHandler? = nil) {
        self.queue.async {
            self.backingCache.removeAllObjects()
            completion?(true)
        }
    }
}
