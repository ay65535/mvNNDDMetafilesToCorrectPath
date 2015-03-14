//#!/usr/bin/env swift
//
//  main.swift
//  mvNNDDMetafilesToCorrectPath
//
//  Created by 安田充志 on 2015/03/14.
//  Copyright (c) 2015年 ay65535. All rights reserved.
//

import Foundation

/**
* ある時刻(0時〜23時)が、指定した時間の範囲内に含まれるかどうかを調べる
* プログラムを作ってください。
*      言語は問いませんが、ライブラリなどを使ってはいけません。
*      以下のような条件を満たすこと。
*      - ある時刻と、時間の範囲(開始時刻と終了時刻)を受け取る。
*      - 時刻は、6時であれば6のような指定でよく、分単位は問わない。
*      - 範囲指定は、開始時刻を含み、終了時刻は含まないと判断すること。
*      - ただし開始時刻と終了時刻が同じ場合は含むと判断すること。
*      - 開始時刻が22時で終了時刻が5時、というような指定をされても動作すること。
*/

let EXIT_TRUE: Int32 = 0
let EXIT_FALSE: Int32 = 1
let EXIT_FAILURE: Int32 = 2
let NULL_POINTER_ERROR: Int = 3
let NUMBER_FORMAT_ERROR = 4
let ARRAY_INDEX_OUT_OF_RANGE: Int = 5

class MyTime {
    var t: Int
    
    init(numStr: String) {
        if let tmpNum: Int = numStr.toInt() {
            self.t = 0 <= tmpNum && tmpNum <= 23 ? tmpNum : NUMBER_FORMAT_ERROR
        } else {
            self.t = NULL_POINTER_ERROR
        }
    }
}

func - (left: MyTime, right: MyTime) -> Int {
    if (left.t >= right.t) {
        return left.t - right.t
    } else {
        return (left.t + 24) - right.t
    }
}

class MyRange {
    var begin: MyTime
    var end: MyTime
    
    init(begin: MyTime, end: MyTime) {
        self.begin = begin
        self.end = end
    }
    
    func contains(time: MyTime) -> Bool {
        return end - begin == 0 && time - begin == 0 || end - begin > time - begin
    }
}

class Main {
    func main(args: [String]) -> Int32 {
        var fileManager = NSFileManager.defaultManager()
        
        let musicPath: AnyObject = NSSearchPathForDirectoriesInDomains(.MusicDirectory,.UserDomainMask,true)[0]
        let destinationPath = musicPath.stringByAppendingString("/iTunes/iTunes Media")
        let dest = "~/Music/iTunes/iTunes Media".stringByExpandingTildeInPath
        
        var filterA = {
            (e: AnyObject) -> Bool in
            if e.hasSuffix(".mp4") {
                return true
            } else {
                return false
            }
        }
        
        var mp4s = fileManager.contentsOfDirectoryAtPath(dest, error: nil) as [String] //?.filter(filterA) as [String]
        
        //println(mp4s)
        func getFilesInDirectory(path: String) -> NSArray! {
            var array = NSMutableArray()
            let str = "mp4"
            let stri = str.cStringUsingEncoding(NSUTF8StringEncoding)
            var dirEnum = fileManager.enumeratorAtPath(path)
            while let name = dirEnum?.nextObject() as? NSString {
                var fullPath = path.stringByAppendingPathComponent(name)  // Full Path
                if let cname = name.componentsSeparatedByString(".").last as? String {
                    //                    if let cstri = stri {
                    //                        if let ccname =
                    let ccname = cname.cStringUsingEncoding(NSUTF8StringEncoding)
                    let aName = ccname
                    let aStr = stri
                    if aName! == aStr! {
                    //println("\(aName) == \(aStr)")
                    println("\(String(UTF8String: aName!)) == \(String(UTF8String: aStr!))")
                        println(name)
                    }
                    //                            if ccname == cstri { // checks the extension
                    //                                println(name)
                    //                                array.addObject(fullPath)
                    ////                            }
                    //                    }
                }
            }
            return array;
        }
        let result = getFilesInDirectory(dest)
        //println("\n\(result)")
        
        return 0
    }
}

//if (4 <= C_ARGC) {
exit(Main().main(Process.arguments))
//}
