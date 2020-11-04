//
//  TinyJSONTokenizerUnitTests.swift
//  TinyJSONUnitTests
//
//  Created by linwenhu on 2020/11/3.
//

import XCTest
@testable
import TinyJSONSource

class TinyJSONTokenizerUnitTests: XCTestCase {

    func testInvalidLiteral() {
        _expect(text: "false", tokenError: JSONError(.invalidLiteral("false")))
        _expect(text: "true", tokenError: JSONError(.invalidLiteral("true")))
        _expect(text: "nul", tokenError: JSONError(.invalidLiteral("null")))
    }
    
    func testNumber() {
        _expect(text: "+0", tokenError: JSONError(.invalidNumber))
        _expect(text: "+1", tokenError: JSONError(.invalidNumber))
        _expect(text: ".123", tokenError: JSONError(.unknown))
        _expect(text: "1.", tokenError: JSONError(.invalidNumber))
        _expect(text: "INF", tokenError: JSONError(.unknown))
        _expect(text: "1.0e2", tokenError: JSONError(.invalidNumber))
        _expect(text: "-1.0e2", tokenError: JSONError(.invalidNumber))
        _expect(text: "-1.e2", tokenError: JSONError(.invalidNumber))
    }
    
    func testMissQuotationMark() {
        _expect(text: "\"", tokenError: JSONError(.missDoubleQuotationMark))
        _expect(text: "\"a", tokenError: JSONError(.missDoubleQuotationMark))
    }
    
    func _testInvalidLiteral(_ literal: String) {
        let t = Tokenizer(text: literal)
        do {
            let _ = try t.next()
            XCTAssert(true)
        } catch {
            if case .invalidNumber = (error as! JSONError).kind {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        }
    }
    
    func _expect(text: String, tokenError: JSONError) {
        let t = Tokenizer(text: text)
        do {
            let _ = try t.next()
            XCTAssert(true)
        } catch {
            if tokenError.kind == (error as! JSONError).kind {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        }
    }
}
