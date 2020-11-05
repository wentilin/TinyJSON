//
//  JSONValue.swift
//  TinyJSONSource
//
//  Created by linwenhu on 2020/11/5.
//

import Foundation

public enum JSONValueType {
    case object
    case array
    case string
    case number
    case bool
}

public protocol JSONValue {
    var type: JSONValueType { get }
    
    func toString() -> String
}

public struct JSONObject: JSONValue, Sequence {
    public typealias Element = (key: String, value: JSONValue?)
    public typealias Iterator = AnyIterator<Element>
    
    public var type: JSONValueType { return .object }
    
    private var storage: [String: JSONValue?] = [:]
    
    subscript(key: String) -> JSONValue? {
        get { return storage[key] ?? nil }
        set { storage[key] = newValue }
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        var innerIterator = storage.makeIterator()
        
        return Iterator { () -> Element? in
            if let element = innerIterator.next() {
                return (element.key, element.value)
            } else {
                return nil
            }
        }
    }
    
    public func toString() -> String {
        var res = "{"
        for item in storage {
            res += item.key.toString()
            res += ":"
            if let value = item.value  {
                res += value.toString()
            } else {
                res += "null"
            }
            
            res += ","
        }
        
        if storage.count > 0 {
            res.removeLast()
        }
        
        res += "}"
        
        return res
    }
}

public struct JSONArray: JSONValue {
    public typealias Element = JSONValue
    public typealias Iterator = AnyIterator<Element>
    
    public var type: JSONValueType { return .object }
    
    private var storage: [JSONValue] = []
    
    mutating func append(_ element: Element) {
        storage.append(element)
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        var innerIterator = storage.makeIterator()
        
        return Iterator { () -> Element? in
            if let element = innerIterator.next() {
                return element
            } else {
                return nil
            }
        }
    }
    
    public func toString() -> String {
        var res = "["
        for item in storage {
            res += item.toString()
            res += ","
        }
        
        if storage.count > 0 {
            res.removeLast()
        }
        
        res += "]"
        
        return res
    }
}

extension String: JSONValue {
    public var type: JSONValueType { return .string }
    
    public func toString() -> String {
        return "\"\(self)\""
    }
}

extension Double: JSONValue {
    public var type: JSONValueType { return .number }
    
    public func toString() -> String {
        return "\(self)"
    }
}

extension Bool: JSONValue {
    public var type: JSONValueType { return .bool }
    
    public func toString() -> String {
        return "\(self)"
    }
}
