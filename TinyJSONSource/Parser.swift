//
//  Parser.swift
//  TinyJSON
//
//  Created by linwenhu on 2020/11/3.
//

import Foundation

public class Parser {
    private var tokenizer: Tokenizer
    private var currentToken: Token
    
    public init(_ json: String) throws {
        self.tokenizer = Tokenizer(text: json)
        currentToken = try tokenizer.next()
    }
    
    public func parse() throws -> JSONValue? {
        return try _parseValue()
    }
    
    private func _parseObject() throws -> JSONObject {
        try _eatToken(.leftBracket)
        
        var objectJSON = JSONObject()
        
        while currentToken.type != .rightBracket, currentToken.type != .eof {
            let key = try _parseString()
            
            try _eatToken(.colon)
            
            let value = try _parseValue()
            
            objectJSON[key] = value
            
            if currentToken.type == .comma {
                try _eatToken(.comma)
            }
        }

        
        try _eatToken(.rightBracket)
        
        return objectJSON
    }
    
    private func _parseArray() throws -> JSONArray {
        try _eatToken(.leftSquareBracket)
        var arr = JSONArray()
        
        while currentToken.type != .rightSquareBracket, currentToken.type != .eof {
            guard let value = try _parseValue() else {
                throw JSONError(.nullInArray)
            }
            
            arr.append(value)
            
            if currentToken.type == .comma {
                try _eatToken(.comma)
            }
        }
        
        try _eatToken(.rightSquareBracket)
        
        return arr
    }
    
    private func _parseString() throws -> String {
        let token = currentToken
        try _eatToken(.string)
        
        return token.value as! String
    }
    
    private func _parseValue() throws -> JSONValue? {
        switch currentToken.type {
        case .bFalse:
            try _eatToken(.bFalse)
            return false
        case .bTrue:
            try _eatToken(.bTrue)
            return true
        case .null:
            try _eatToken(.null)
            return nil
        case .number:
            let value = currentToken.value
            try _eatToken(.number)
            return value as? Double
        case .string:
            let value = currentToken.value
            try _eatToken(.string)
            return value as? String
        case .leftBracket:
            return try _parseObject()
        case .leftSquareBracket:
            return try _parseArray()
        case .eof:
            return nil
        default:
            throw JSONError(.invalid)
        }
    }
    
    private func _eatToken(_ type: TokenType) throws {
        guard currentToken.type == type else {
            throw JSONError(.unexpect)
        }
        
        currentToken = try tokenizer.next()
    }
}
