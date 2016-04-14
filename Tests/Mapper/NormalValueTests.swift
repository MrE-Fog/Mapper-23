// NormalValueTests.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Oleg Dreyman
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
@testable import Mapper

class NormalValueTests: XCTestCase {
    static var allTests: [(String, NormalValueTests -> () throws -> Void)] {
        return [
            ("testMappingString", testMappingString),
            ("testMappingMissingKey", testMappingMissingKey),
            ("testFallbackMissingKey", testFallbackMissingKey),
            ("testArrayOfStrings", testArrayOfStrings),
            ("testPartiallyInvalidArrayOfValues", testPartiallyInvalidArrayOfValues)
        ]
    }

    func testMappingString() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        
        let test = try! Test(map: Mapper(structuredData: ["string": "Hello"]))
        XCTAssertTrue(test.string == "Hello")
    }
    
    func testMappingMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo")
            }
        }
        
        let test = try? Test(map: Mapper(structuredData: [:]))
        XCTAssertNil(test)
    }
    
    func testFallbackMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                self.string = map.optionalFrom("foo") ?? "Hello"
            }
        }
        
        let test = try! Test(map: Mapper(structuredData: [:]))
        XCTAssertTrue(test.string == "Hello")
    }
    
    func testArrayOfStrings() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.arrayFrom("strings")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["strings": ["first", "second"]]))
        XCTAssertEqual(test.strings.count, 2)
    }
    
    func testPartiallyInvalidArrayOfValues() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.arrayFrom("strings")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["strings": ["first", "second", 3]]))
        XCTAssertEqual(test.strings.count, 2)
    }
}