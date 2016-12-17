//
//  GenericCacheTests.swift
//  Relical
//
//  Created by Marcel Dierkes on 03.08.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation
import XCTest
import Relical

enum SharedTestData {
    static let dictionary: (String, NSDictionary) = ("dictionary", [
        "key1": "String",
        "key2": 14.0,
        "key3": true
    ])
    
    static let blobData: (String, NSData) = ("blob", {
        class BundleHelper {}
        let URL = Bundle(for: BundleHelper.self).url(forResource: "TestPhoto", withExtension: "png")!
        return (try! NSData(contentsOf: URL))
    }())
}

final class GenericCacheTests {
    
    // MARK: Set
    static func setValue(cache: AsynchronousCache, completion: @escaping () -> Void) {
        let (key, value) = SharedTestData.dictionary
        
        cache.set(value: value, forKey: key) { success in
            XCTAssertTrue(success)
            completion()
        }
    }
    
    static func setLargeValue(cache: AsynchronousCache, completion: @escaping () -> Void) {
        let (key, value) = SharedTestData.blobData
        
        cache.set(value: value, forKey: key) { success in
            XCTAssertTrue(success)
            completion()
        }
    }
    
    // MARK: Get
    static func getValue(cache: AsynchronousCache, isExpired: Bool = false, completion: @escaping () -> Void) {
        let (key, value) = SharedTestData.dictionary
        
        let expirationDate: Date?
        if isExpired {
            expirationDate = Date(timeIntervalSince1970: 20) // the past
        } else {
            expirationDate = nil
        }
        
        cache.set(value: value, forKey: key, expirationDate: expirationDate) { success in
            XCTAssertTrue(success)
            
            cache.value(forKey: key) { (retrievedValue: NSDictionary?) in
                if isExpired {
                    XCTAssertNil(retrievedValue)
                } else {
                    XCTAssertEqual(value, retrievedValue)
                }
                completion()
            }
        }
    }
    
    static func getLargeValue(cache: AsynchronousCache, isExpired: Bool = false, completion: @escaping () -> Void) {
        let (key, value) = SharedTestData.blobData
        
        let expirationDate: Date?
        if isExpired {
            expirationDate = Date(timeIntervalSince1970: 20) // the past
        } else {
            expirationDate = nil
        }
        
        cache.set(value: value, forKey: key, expirationDate: expirationDate) { success in
            XCTAssertTrue(success)
            
            cache.value(forKey: key) { (retrievedValue: NSData?) in
                if isExpired {
                    XCTAssertNil(retrievedValue)
                } else {
                    XCTAssertEqual(value, retrievedValue)
                }
                completion()
            }
        }
    }
    
    // MARK: Remove
    static func removeValue(cache: AsynchronousCache, completion: @escaping () -> Void) {
        let (key, value) = SharedTestData.dictionary
        
        cache.set(value: value, forKey: key) { success in
            XCTAssertTrue(success)
            
            cache.removeValue(forKey: key) { success in
                XCTAssertTrue(success)
                
                cache.removeValue(forKey: key) { success in
                    XCTAssertFalse(success)
                    
                    cache.value(forKey: key) { (value: NSDictionary?) in
                        XCTAssertNil(value)
                        completion()
                    }
                }
            }
        }
    }
    
    static func removeLargeValue(cache: AsynchronousCache, completion: @escaping () -> Void) {
        let (key, value) = SharedTestData.blobData
        
        cache.set(value: value, forKey: key) { success in
            XCTAssertTrue(success)
            
            cache.removeValue(forKey: key) { success in
                XCTAssertTrue(success)
                
                cache.removeValue(forKey: key) { success in
                    XCTAssertFalse(success)
                    
                    cache.value(forKey: key) { (value: NSData?) in
                        XCTAssertNil(value)
                        completion()
                    }
                }
            }
        }
    }
    
    // MARK: Remove All
    static func removeAllValues(cache: AsynchronousCache, completion: @escaping () -> Void) {
        let (key1, value1) = SharedTestData.dictionary
        let (key2, value2) = SharedTestData.blobData
        
        cache.set(value: value1, forKey: key1) { success in
            XCTAssertTrue(success)
            
            cache.set(value: value2, forKey: key2) { success in
                XCTAssertTrue(success)
                
                cache.removeAllValues { success in
                    // Make sure there is no remaining value
                    cache.value(forKey: key1) { (value: NSDictionary?) in
                        XCTAssertNil(value)
                        
                        completion()
                    }
                }
            }
        }
    }
}
