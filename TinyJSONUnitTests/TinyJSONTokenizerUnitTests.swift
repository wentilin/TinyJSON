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
        _expect(text: "false", tokenError: TokenError(kind: .invalidLiteral("false")))
        _expect(text: "true", tokenError: TokenError(kind: .invalidLiteral("true")))
        _expect(text: "nul", tokenError: TokenError(kind: .invalidLiteral("null")))
    }
    
    func testNumber() {
        _expect(text: "+0", tokenError: TokenError(kind: .invalidNumber))
        _expect(text: "+1", tokenError: TokenError(kind: .invalidNumber))
        _expect(text: ".123", tokenError: TokenError(kind: .unknown))
        _expect(text: "1.", tokenError: TokenError(kind: .invalidNumber))
        _expect(text: "INF", tokenError: TokenError(kind: .unknown))
        _expect(text: "1.0e2", tokenError: TokenError(kind: .invalidNumber))
        _expect(text: "-1.0e2", tokenError: TokenError(kind: .invalidNumber))
        _expect(text: "-1.e2", tokenError: TokenError(kind: .invalidNumber))
    }
    
    func testMissQuotationMark() {
        _expect(text: "\"", tokenError: TokenError(kind: .missDoubleQuotationMark))
        _expect(text: "\"a", tokenError: TokenError(kind: .missDoubleQuotationMark))
    }
    
    func _testInvalidLiteral(_ literal: String) {
        let t = Tokenizer(text: literal)
        do {
            let _ = try t.next()
            XCTAssert(true)
        } catch {
            if case .invalidNumber = (error as! TokenError).kind {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        }
    }
    
    func _expect(text: String, tokenError: TokenError) {
        let t = Tokenizer(text: text)
        do {
            let _ = try t.next()
            XCTAssert(true)
        } catch {
            if tokenError.kind == (error as! TokenError).kind {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        }
    }
}
