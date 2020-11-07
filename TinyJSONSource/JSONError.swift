//
//  JSONError.swift
//  TinyJSONSource
//
//  Created by linwenhu on 2020/11/4.
//

import Foundation

public struct JSONError: Error, CustomStringConvertible {
    public enum ErrorKind: Equatable {
        case missDoubleQuotationMark
        case invalidNumber
        case invalidLiteral(_ literal: String)
        case eof
        case unknown
        
        case nullInArray
        case unexpect
        case invalid
    }
    
    public var kind: ErrorKind
    public var line: Int
    public var charIndex: Int
    
    init(_ kind: ErrorKind, line: Int, charIndex: Int) {
        self.kind = kind
        self.line = line
        self.charIndex = charIndex
    }
    
    public var description: String {
        switch kind {
        case .missDoubleQuotationMark:
            return "JSON error(\(line):\(charIndex)): miss double quotation mark"
        case .invalidNumber:
            return "JSON error(\(line):\(charIndex)): invalid number"
        case .invalidLiteral(let literal):
            return "JSON error(\(line):\(charIndex)): invalid literal(\(literal))"
        case .eof:
            return "JSON error(\(line):\(charIndex)): eof"
        case .nullInArray:
            return "JSON error(\(line):\(charIndex)): array contains null element"
        case .unexpect:
            return "JSON error(\(line):\(charIndex)): unexpect token"
        case .invalid:
            return "JSON error(\(line):\(charIndex)): invalid"
        default:
            return "JSON error(\(line):\(charIndex)): unknown error"
        }
    }
}
