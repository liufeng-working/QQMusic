//
//  LFDataTool.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFDataTool: NSObject {
    
    public static func musicModels(result: (_ musicMs: [LFMusicModel]) -> ()) {
        guard let path = Bundle.main.path(forResource: "musics.plist", ofType: nil),
        let array = NSArray(contentsOfFile: path) else {
            result([LFMusicModel]())
            return
        }
        
        var musicMs = [LFMusicModel]()
        for dict in array {
            let musicM = LFMusicModel(dict: dict as! [String: Any])
            musicMs.append(musicM)
        }
        result(musicMs)
    }
    
    public static func lrcModels(lrcName: String, result: (_ lrcMs: [LFLrcModel]) -> ()) {
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil),
            let lrcStr = try? String(contentsOfFile: path) else {
                result([LFLrcModel]())
                return
        }
        
        let lrcs = lrcStr.components(separatedBy: "\n")
        var lrcMs = [LFLrcModel]()
        var lastM = LFLrcModel()
        for lrc in lrcs.reversed() {
            if lrc.contains("[ti:") || lrc.contains("[ar:") || lrc.contains("[al:") {
                continue
            }
            
            let lrc1 = lrc.replacingOccurrences(of: "[", with: "")
            let timeAndLrc = lrc1.components(separatedBy: "]")
            if timeAndLrc.count != 2 {
                continue
            }
            
            let lrcM = LFLrcModel()
            lrcM.startTimeStr = timeAndLrc.first!
            lrcM.endTimeStr = lastM.startTimeStr
            lrcM.lrc = timeAndLrc.last!
            lrcMs.append(lrcM)
            
            lastM = lrcM
        }
        result(lrcMs.reversed())
    }

    public static func currentLrcModel(currentTime: TimeInterval, lrcMs: [LFLrcModel]) -> (lrcM: LFLrcModel?, row: Int) {
        for lrcM in lrcMs {
            if currentTime >= lrcM.startTime && currentTime < lrcM.endTime {
                return (lrcM, lrcMs.index(of: lrcM)!)
            }
        }
        return (nil, 0)
    }
}
