//
//  LFDetailModel.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFDetailModel: NSObject {
    
    var musicM: LFMusicModel?
    
    var costTime: TimeInterval = 0
    var costTimeStr: String {
        return Date.mediaString(second: self.costTime)
    }
    
    var totleTime: TimeInterval = 0 {
        didSet {
            self.totleTimeStr = Date.mediaString(second: self.totleTime)
        }
    }
    var totleTimeStr: String = "00:00"
    
    var isPlaying: Bool = false
}
