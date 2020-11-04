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
    
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
    
    public var description: String {
        switch kind {
        case .missDoubleQuotationMark:
            return "JSON error: miss double quotation mark"
        case .invalidNumber:
            return "JSON error: invalid number"
        case .invalidLiteral(let literal):
            return "JSON error: invalid literal(\(literal))"
        case .eof:
            return "JSON error: eof"
        case .nullInArray:
            return "JSON error: array contains null element"
        case .unexpect:
            return "JSON error: unexpect token"
        case .invalid:
            return "JSON error: invalid"
        default:
            return "JSON error: unknown error"
        }
    }
}
