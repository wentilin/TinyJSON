//
//  Tokenizer.swift
//  TinyJSON
//
//  Created by linwenhu on 2020/11/3.
//

import Foundation

public class Tokenizer {
    private var stack: [String] = []
    private var position: Int = 0
    private var current: String = ""
    
    public var isEnd: Bool { return position == stack.count }
    
    public var line: Int { return _line_ }
    public var charIndex: Int { return _charIndex_ }
    
    public init(text: String) {
        for ch in text {
            stack.append(String(ch))
        }
        
        if !stack.isEmpty {
            current = stack[position]
        }
    }
    
    public func next() throws -> Token {
        while true {
            if current.isWhiteSpace {
                skipWhiteSpace()
            } else if current == "{" {
                advance()
                return .init(type: .leftBracket, value: "{")
            } else if current == "}" {
                advance()
                return .init(type: .rightBracket, value: "}")
            } else if current == "[" {
                advance()
                return .init(type: .leftSquareBracket, value: "[")
            } else if current == "]" {
                advance()
                return .init(type: .rightSquareBracket, value: "]")
            } else if current == ":" {
                advance()
                return .init(type: .colon, value: ":")
            } else if current == "," {
                advance()
                return .init(type: .comma, value: ",")
            } else if current == "\"" {
                advance()
                var str = ""
                while !isEnd, current != "\"" {
                    str += current
                    advance()
                }
                
                if current == "\"" {
                    advance()
                } else {
                    throw JSONError(.missDoubleQuotationMark, line: line, charIndex: charIndex)
                }
                
                return .init(type: .string, value: str)
            } else if current.isDigit || current == "-" || current == "+" {
                return try numberToken()
            } else if current == "t" {
                return try literalToken(literal: "true", type: .bTrue)
            } else if current == "f" {
                return try literalToken(literal: "false", type: .bFalse)
            } else if current == "n" {
                return try literalToken(literal: "null", type: .null)
            } else if isEnd {
                return .init(type: .eof, value: "eof")
            } else {
                throw JSONError(.unknown, line: line, charIndex: charIndex)
            }
        }
    }
    
    private func advance() {
        position += 1
        
        if position >= stack.count {
            current = ""
            return
        }
        
        _charIndex_ += 1
        current = stack[position]
        
        if current == "\n" || current == "\t" {
            _line_ += 1
            _charIndex_ = 0
        }
    }
    
    private func skipWhiteSpace() {
        while current.isWhiteSpace {
            advance()
        }
    }
    
    private func numberToken() throws -> Token {
        var numStr: String = ""
        if current == "-" || current == "+" {
            numStr += current
            advance()
        }
        
        guard current.isDigit else {
            throw JSONError(.invalidNumber, line: line, charIndex: charIndex)
        }
        
        if current == "0" {
            numStr += "0"
            advance()
        } else {
            while !isEnd, current.isDigit {
                numStr += current
                advance()
            }
        }
        
        if current == "." {
            numStr += current
            advance()
            
            guard current.isDigit else {
                throw JSONError(.invalidNumber, line: line, charIndex: charIndex)
            }
            
            while current.isDigit {
                numStr += current
                advance()
            }
        }
        
        if current == "e" || current == "E" {
            numStr += current
            advance()
            
            if current == "+" || current == "-" {
                numStr += current
                advance()
            }
            
            guard current.isDigit else {
                throw JSONError(.invalidNumber, line: line, charIndex: charIndex)
            }
            
            while current.isDigit {
                numStr += current
                advance()
            }
        }

        guard let num = Double(numStr) else {
            throw JSONError(.invalidNumber, line: line, charIndex: charIndex)
        }
        
        return .init(type: .number, value: num)
    }
    
    private func literalToken(literal: String, type: TokenType) throws -> Token {
        let literalChs = literal.map{ String($0) }
        for i in 0..<literalChs.count {
            if literalChs[i] == current && !isEnd {
                advance()
            } else {
                throw JSONError(.invalidLiteral(literal), line: line, charIndex: charIndex)
            }
        }
        
        return Token(type: type, value: literal)
    }
    
    public var _line_: Int = 1
    public var _charIndex_: Int = 1
}

extension String {
    var isWhiteSpace: Bool {
        return self == " " || self == "\n" || self == "\t"
    }
    
    var isDigit: Bool {
        return self >= "0" && self <= "9"
    }
}
