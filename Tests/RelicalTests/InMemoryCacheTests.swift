//
//  InMemoryCacheTests.swift
//  Relical
//
//  Created by Marcel Dierkes on 29.06.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import XCTest
import Relical

class InMemoryCacheTests: XCTestCase {
    fileprivate var cache: AsynchronousCache!
    
    override func setUp() {
        super.setUp()
        self.cache = InMemoryCache()
    }
    
    override func tearDown() {
        self.cache = nil
        super.tearDown()
    }
    
    func testSetValue() {
        let identifier = "InMemoryCacheTests-testSetValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.setValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testSetLargeValue() {
        let identifier = "InMemoryCacheTests-testSetLargeValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.setLargeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetValue() {
        let identifier = "InMemoryCacheTests-testGetValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetValueExpired() {
        let identifier = "InMemoryCacheTests-testGetValueExpired"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getValue(cache: self.cache, isExpired: true) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetLargeValue() {
        let identifier = "InMemoryCacheTests-testGetLargeValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getLargeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testGetLargeValueExpired() {
        let identifier = "InMemoryCacheTests-testGetLargeValueExpired"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.getLargeValue(cache: self.cache, isExpired: true) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testRemoveValue() {
        let identifier = "InMemoryCacheTests-testRemoveValue"
        
        measure {
            let expectation = self.expectation(description: identifier)
            GenericCacheTests.removeValue(cache: self.cache) {
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
    
    func testRemoveLargeValue() {
        let identifier = "InMemoryCacheTests-testRemoveLargeValue"
        
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
    
//    
//    func testInMemoryCacheRemoveAllValues() {
//        let (key1, value1) = SharedTestData.PDFData
//        let (key2, value2) = SharedTestData.dictionary
//        
//        measureBlock {
//            let expectation = self.expectationWithDescription("testInMemoryCacheRemoveAllValues")
//            self.cache.set(value: value1, forKey: key1) { success in
//                XCTAssertTrue(success)
//                
//                self.cache.set(value: value2, forKey: key2) { success in
//                    XCTAssertTrue(success)
//                    
//                    self.cache.removeAllValues { success in
//                        XCTAssertTrue(success)
//                        
//                        expectation.fulfill()
//                    }
//                }
//            }
//            self.waitForExpectationsWithTimeout(5.0, handler: nil)
//        }
//    }
    
}
