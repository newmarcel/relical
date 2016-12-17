import XCTest
@testable import RelicalTests

XCTMain([
    testCase(CacheItemTests.allTests),
    testCase(DiskCacheTests.allTests),
    testCase(InMemoryCacheTests.allTests)
])
