//
//  main.swift
//  TinyJSON
//
//  Created by linwenhu on 2020/11/3.
//

import Foundation
import TinyJSONSource

let t = Tokenizer(text: "{123.0E10, null, 1.0e2")
while !t.isEnd {
    do {
        print(try t.next())
    } catch {
        print(error)
    }
    
}

do {
    let parser = try Parser("{\n\"person\":\n\"你好}")
    let value = try parser.parse()
    print(value!.toString())
} catch {
    print(error)
}
