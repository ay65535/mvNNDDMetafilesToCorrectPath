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
 *
 */

let EXIT_TRUE: Int32 = 0
let EXIT_FALSE: Int32 = 1
let EXIT_FAILURE: Int32 = 2
let NULL_POINTER_ERROR: Int = 3
let NUMBER_FORMAT_ERROR = 4
let ARRAY_INDEX_OUT_OF_RANGE: Int = 5

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
        func getFilesInDirectory(path: String) -> (NSArray!, NSArray!, NSArray!) {
            var array = NSMutableArray()
            var mp4s = NSMutableArray()
            var xmls = NSMutableArray()
            var dirEnum = fileManager.enumeratorAtPath(path)
            while let name = dirEnum?.nextObject() as? NSString {
                var fullPath: NSString = path.stringByAppendingPathComponent(name)  // Full Path
                if name.hasSuffix(".mp4") || name.hasSuffix("[ThumbInfo].xml") {
                    let pattern = "(\\.mp4|\\[ThumbInfo\\]\\.xml)"
                    let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
                    //regex?.firstMatchInString(fullPath, options: nil, range: NSMakeRange(0, fullPath.length))
                    regex?.enumerateMatchesInString(fullPath, options: nil, range: NSMakeRange(0, fullPath.length),
                        usingBlock: {(result: NSTextCheckingResult!, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                            for i in 0...result.numberOfRanges - 1 {
                                let range = result.rangeAtIndex(i)
                                //println(fullPath.substringWithRange(range1))
                                let basename = fullPath.substringWithRange(NSMakeRange(0, range.location))
                                array.addObject(basename)
                            }
                    })
                    
                    if name.hasSuffix(".mp4") {
                        mp4s.addObject(fullPath)
                    } else {
                        xmls.addObject(fullPath)
                    }
                }
            }
            return (array, mp4s, xmls)
        }
        let result = getFilesInDirectory(dest)
        //println("\n\(result)")
        
        return 0
    }

//if (4 <= C_ARGC) {
exit(main(Process.arguments))
//}
