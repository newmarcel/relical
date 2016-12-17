//
//  AsynchronousCache.swift
//  Relical
//
//  Created by Marcel Dierkes on 29.06.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation

/// Cache access completion handler
public typealias CacheCompletionHandler = (_ success: Bool) -> Void

/// A protocol describing an asynchronous cache interface.
public protocol AsynchronousCache {
    func set<Value: NSCoding>(value: Value, forKey key: String, expirationDate: Date?, completion: CacheCompletionHandler?)
    func set<Value: NSCoding>(value: Value, forKey key: String, completion: CacheCompletionHandler?)
    func value<Value: NSCoding>(forKey key: String, completion: @escaping (_ value: Value?) -> Void)
    func removeValue(forKey key: String, completion: CacheCompletionHandler?)
    func removeAllValues(completion: CacheCompletionHandler?)
}

public extension AsynchronousCache {
    public func set<Value: NSCoding>(value: Value, forKey key: String, completion: CacheCompletionHandler?) {
        self.set(value: value, forKey: key, expirationDate: nil, completion: completion)
    }
}
