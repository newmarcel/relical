//
//  CacheItem.swift
//  Relical
//
//  Created by Marcel Dierkes on 29.06.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation

private struct CoderKeys {
    static let value = "value"
    static let createdAt = "createdAt"
    static let expirationDate = "expirationDate"
}

/// A cache entry representation with metadata.
public final class CacheItem<Value: NSCoding>: NSObject, NSSecureCoding {
    
    // MARK: - Properties
    
    /// The cached value
    public let value: Value
    
    /// The creation date
    public let createdAt: Date
    
    /// An optional expiration date
    public let expirationDate: Date?
    
    /// Returns if `expirationDate` lies in the past
    public var isExpired: Bool {
        return self.expirationDate?.isExpired ?? false
    }
    
    // MARK: - Life Cycle
    
    /// The designed initializer.
    ///
    /// - Parameters:
    ///   - value: A cache value
    ///   - expirationDate: An optional expiration date, defaults to nil
    public required init(value: Value, expirationDate: Date? = nil) {
        self.value = value
        self.createdAt = Date()
        self.expirationDate = expirationDate
        super.init()
    }
    
    // MARK: - NSCoding
    
    public static var supportsSecureCoding : Bool {
        return true
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.value, forKey: CoderKeys.value)
        aCoder.encode(self.createdAt, forKey: CoderKeys.createdAt)
        aCoder.encode(self.expirationDate, forKey: CoderKeys.expirationDate)
    }
    
    public init?(coder aDecoder: NSCoder) {
        guard let value = aDecoder.decodeObject(forKey: CoderKeys.value) as? Value else { return nil }
        guard let createdAt = aDecoder.decodeObject(forKey: CoderKeys.createdAt) as? Date else { return nil }
        self.value = value
        self.createdAt = createdAt
        self.expirationDate = aDecoder.decodeObject(forKey: CoderKeys.expirationDate) as? Date
    }
}

// MARK: - NSDate + Expiration Check
fileprivate extension Date {
    /// Returns true, if the date lies in the past
    var isExpired: Bool {
        return self.timeIntervalSinceNow < 0
    }
}
