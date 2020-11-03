//
//  Parser.swift
//  TinyJSON
//
//  Created by linwenhu on 2020/11/3.
//

import Foundation

enum JSONType {
    case number
    case string
    case object
    case array
    case bTrue
    case bFalse
    case null
}

protocol JSONValue {}

extension Array: JSONValue where Element == JSONValue {}

extension Dictionary: JSONValue where Value == JSONValue {}

extension String: JSONValue {}

extension Bool: JSONValue {}

extension Double: JSONValue {}

protocol TinyJSON {
    var type: JSONType { get set }
    var value: JSONValue { get set }
}

struct ArrayJSON: TinyJSON {
    var type: JSONType
    
    var value: JSONValue {
        get { return _value }
        set { _value = newValue as! Array<JSONValue> }
    }
    
    var _value: Array<JSONValue> = []
}

struct ObjectJSON: TinyJSON {
    var type: JSONType
    
    var value: JSONValue {
        get { return _value }
        set { _value = newValue as! [String: JSONValue] }
    }
    
    var _value: [String: JSONValue] = [:]
}

class Parser {
    
    
    func parse(json: String) -> TinyJSON? {
        return nil
    }
    
    private func _parseObject() {
        
    }
}
