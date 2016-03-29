//
//  NormalValueTests.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import InterchangeDataMapper

class NormalValueTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMappingString() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        
        let test = try! Test(map: Mapper(interchangeData: ["string": "Hello"]))
        XCTAssertTrue(test.string == "Hello")
    }
    
    func testMappingMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo")
            }
        }
        
        let test = try? Test(map: Mapper(interchangeData: [:]))
        XCTAssertNil(test)
    }
    
    func testFallbackMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                self.string = map.optionalFrom("foo") ?? "Hello"
            }
        }
        
        let test = try! Test(map: Mapper(interchangeData: [:]))
        XCTAssertTrue(test.string == "Hello")
    }
    
    func testArrayOfStrings() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.arrayFrom("strings")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["strings": ["first", "second"]]))
        XCTAssertEqual(test.strings.count, 2)
    }
    
    func testPartiallyInvalidArrayOfValues() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.arrayFrom("strings")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["strings": ["first", "second", 3]]))
        XCTAssertEqual(test.strings.count, 2)
    }
    
}
