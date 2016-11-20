//
//  CacheItemTests.swift
//  Relical
//
//  Created by Marcel Dierkes on 09.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import XCTest
import Relical

class CacheItemTests: XCTestCase {
    fileprivate var encodedItem: (CacheItem<NSDictionary>, Data) {
        let value: NSDictionary = [
            "key1": "String",
            "key2": 14.0,
            "key3": true
        ]
        let expiresAt = Date(timeIntervalSinceNow: 12*60*60)
        let item = CacheItem(value: value, expirationDate: expiresAt)
        return (item, NSKeyedArchiver.archivedData(withRootObject: item))
    }
    
    func testCacheItemDecodingSuccessful() {
        // Encode
        let (item, data) = self.encodedItem
        
        // Decode
        let object = NSKeyedUnarchiver.unarchiveObject(with: data) as? CacheItem<NSDictionary>
        XCTAssertEqual(item.value, object?.value)
        XCTAssertEqual(item.createdAt, object?.createdAt)
        XCTAssertEqual(item.expirationDate, object?.expirationDate)
        XCTAssertEqual(item.isExpired, object?.isExpired)
        XCTAssertFalse(item.isExpired)
        let supportsSecureCoding1 = type(of: item).supportsSecureCoding
        let supportsSecureCoding2 = type(of: object!).supportsSecureCoding
        XCTAssertEqual(supportsSecureCoding1, supportsSecureCoding2)
    }
    
    func testCacheItemExpiration() {
        let (notExpiredItem, _) = self.encodedItem
        XCTAssertFalse(notExpiredItem.isExpired)
        
        let nilExpiredItem = CacheItem(value: notExpiredItem.value, expirationDate: nil)
        XCTAssertFalse(nilExpiredItem.isExpired)
        
        let expiredDate = Date(timeIntervalSince1970: 10)
        let expiredItem = CacheItem(value: notExpiredItem.value, expirationDate: expiredDate)
        XCTAssertTrue(expiredItem.isExpired)
    }
    
    func testCacheItemDecodingFailed() {
        // Encode
        let (item, data) = self.encodedItem
        
        // Decode
        typealias UnrelatedType = NSNumber
        let unrelatedObject = NSKeyedUnarchiver.unarchiveObject(with: data) as? CacheItem<UnrelatedType>
//        print(unrelatedObject?.value)  // FIXME
        XCTAssertNotEqual(item, unrelatedObject)
    }
}
