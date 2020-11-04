//
//  Token.swift
//  TinyJSON
//
//  Created by linwenhu on 2020/11/3.
//

import Foundation

public enum TokenType {
    case string
    case number
    case leftBracket
    case rightBracket
    case leftSquareBracket
    case rightSquareBracket
    case bTrue
    case bFalse
    case colon
    case comma
    case null
    case eof
}

public struct Token {
    var type: TokenType
    var value: Any
}
