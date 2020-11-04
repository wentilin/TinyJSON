//
//  TinyJSONParserUnitTests.swift
//  TinyJSONUnitTests
//
//  Created by linwenhu on 2020/11/4.
//

import XCTest

@testable
import TinyJSONSource

class TinyJSONParserUnitTests: XCTestCase {
    func testNull() throws {
        let res = _expect(json: "null", jsonError: .init(.invalid))
        XCTAssert(res == nil)
    }
    
    func testTrue() throws {
        let res = _expect(json: "true", jsonError: .init(.invalid))
        guard let r = res as? Bool else {
            XCTAssert(false)
            return
        }
        XCTAssert(r == true)
    }
    
    func testFalse() throws {
        let res = _expect(json: "false", jsonError: .init(.invalid))
        guard let r = res as? Bool else {
            XCTAssert(false)
            return
        }
        XCTAssert(r == false)
    }
    
    func testString() {
        _testString(expect: "Hello", json: "\"Hello\"")
        _testString(expect: "", json: "\"\"")
    }
    
    func testArray() {
        _testArray(json: "[false , true , 123 , \"abc\" ]")
        _testArray(json: "[null, false , true , 123 , \"abc\" ]", jsonError: .init(.nullInArray))
        _testArray(json: "[ [ ] , [ 0 ] , [ 0 , 1 ] , [ 0 , 1 , 2 ] ]")
    }
    
    func testObject() {
        _expect(json: """
                {
                    \"n\" : null ,
                    \"f\" : false ,
                    \"t\" : true ,
                    \"i\" : 123 ,
                    \"s\" : \"abc\",
                    \"a\" : [ 1, 2, 3 ],
                    \"o\" : { \"1\" : 1, \"2\" : 2, \"3\" : 3 }
                 }
                """, jsonError: .init(.invalid))
    }
    
    func testInvalid() {
        _testInvalid(json: ".123")
        _testInvalid(json: "1.")
        _testInvalid(json: "INF")
        _testInvalid(json: "inf")
        _testInvalid(json: "NAN")
        _testInvalid(json: "nan")
        _testInvalid(json: "[1,")
        _testInvalid(json: "[\"a\", nul]")
    }
    
    @discardableResult
    func _expect(json: String, jsonError: JSONError) -> Any? {
        do {
            let p = try Parser(json)
            let value = try p.parse()
            XCTAssert(true)
            return value
        } catch {
            if jsonError.kind == (error as! JSONError).kind {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        }
        
        return nil
    }
    
    func _testString(expect: String, json: String) {
        do {
            let p = try Parser(json)
            let res = try p.parse() as! String
            XCTAssertEqual(expect, res)
        } catch {
            XCTAssert(false)
        }
    }
    
    func _testArray(json: String, jsonError: JSONError = .init(.invalid)) {
        _expect(json: json, jsonError: jsonError)
    }
    
    func _testInvalid(json: String) {
        do {
            let p = try Parser(json)
            let _ = try p.parse()
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }
}
