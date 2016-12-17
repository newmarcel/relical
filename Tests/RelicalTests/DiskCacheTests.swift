//
//  DiskCacheTests.swift
//  Relical
//
//  Created by Marcel Dierkes on 01.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import XCTest
@testable import Relical

class DiskCacheTests: XCTestCase {
    fileprivate var cache: AsynchronousCache!
    fileprivate var diskCache: DiskCache! { return self.cache as? DiskCache }
    
    override func setUp() {
        super.setUp()
        self.cache = DiskCache(cacheName: "DiskCacheTests")
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: self.diskCache.url)
        self.cache = nil
        super.tearDown()
    }
    
    func testSetValue() {
        let identifier = "DiskCacheTests-testSetValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.setValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testSetLargeValue() {
        let identifier = "DiskCacheTests-testSetLargeValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.setLargeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetValue() {
        let identifier = "DiskCacheTests-testGetValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetValueExpired() {
        let identifier = "DiskCacheTests-testGetValueExpired"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getValue(cache: self.cache, isExpired: true) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetLargeValue() {
        let identifier = "DiskCacheTests-testGetLargeValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getLargeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetLargeValueExpired() {
        let identifier = "DiskCacheTests-testGetLargeValueExpired"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getLargeValue(cache: self.cache, isExpired: true) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testRemoveValue() {
        let identifier = "DiskCacheTests-testRemoveValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.removeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testRemoveLargeValue() {
        let identifier = "DiskCacheTests-testRemoveLargeValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.removeLargeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testRemoveAllValues() {
        let identifier = "DiskCacheTests-testRemoveAllValues"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.removeAllValues(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testRemoveAllValuesFailed() {
        let identifier = "DiskCacheTests-testRemoveAllValuesFailed"
        
        let cache = DiskCache(cacheName: "DiskCacheTestsRemoveAllValues")
        
        let (key1, value1) = SharedTestData.dictionary
        let (key2, value2) = SharedTestData.blobData
        
        measure {
            let expectation = self.expectation(description: identifier)
            
            cache.set(value: value1, forKey: key1) { success in
                XCTAssertTrue(success)
                
                cache.set(value: value2, forKey: key2) { success in
                    XCTAssertTrue(success)
                    
                    // Already delete the directory before calling removeAllValues
                    _ = try? FileManager.default.removeItem(at: cache.url)
                    
                    cache.removeAllValues { success in
                        // Make sure there is no remaining value
                        cache.value(forKey: key1) { (value: NSDictionary?) in
                            XCTAssertNil(value)
                            
                            expectation.fulfill()
                        }
                    }
                }
            }
            
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }

    // MARK: - Purged In-Memory Cache
    
    func testGetValuePurged() {
        let identifier = "DiskCacheTests-testGetValuePurged"
        
        let cache: DiskCache! = self.diskCache
        let (key, value) = SharedTestData.dictionary
        
        measure {
            let expectation = self.expectation(description: identifier)
            
            cache.set(value: value, forKey: key) { success in
                XCTAssertTrue(success)
                
                // Purge the in-memory cache
                cache.purgeMemory {
                    cache.value(forKey: key) { (retrievedValue: NSDictionary?) in
                        XCTAssertEqual(value, retrievedValue)
                        
                        expectation.fulfill()
                    }
                }
            }
            
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetLargeValuePurged() {
        let identifier = "DiskCacheTests-testGetLargeValuePurged"
        
        let cache: DiskCache! = self.diskCache
        let (key, value) = SharedTestData.blobData
        
        measure {
            let expectation = self.expectation(description: identifier)
            
            cache.set(value: value, forKey: key) { success in
                XCTAssertTrue(success)
                
                // Purge the memory cache
                cache.purgeMemory {
                    cache.value(forKey: key) { (retrievedValue: NSData?) in
                        XCTAssertEqual(value, retrievedValue)
                        
                        expectation.fulfill()
                    }
                }
            }
            
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
}
