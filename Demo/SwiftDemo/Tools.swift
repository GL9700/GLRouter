//
//  Tools.swift
//  SwiftDemo
//
//  Created by liguoliang on 2021/3/1.
//

import UIKit

class Tools: NSObject {
    
    class func sendMessage() {
        print("\(#function)")
    }
    
    class func sendMessage(_ message:String) {
        print("\(message)")
    }

    class func sendMessage(_ msg:String, from:String, to:String) -> Void {
        print("\(#function), \(from)->\(to) : \(msg)")
    }

    class func sum(a:Int, b:Int) -> Int {
        a+b;
    }
}
