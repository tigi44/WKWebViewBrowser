//
//  File.swift
//  
//
//  Created by tigi KIM on 2021/02/17.
//

import Foundation

func PrintDebugLog<T>(_ log: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let info = "\(Date()) \(file.components(separatedBy: "/").last ?? "").\(function)[\(line)]: \(log)"
    debugPrint(info)
    #endif
}
