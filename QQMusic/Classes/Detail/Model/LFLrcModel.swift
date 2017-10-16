//
//  LFLrcModel.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFLrcModel: NSObject {
    
    var startTimeStr: String? {
        didSet {
            
            if let string = self.startTimeStr {
                self.startTime = Date.second(with: string)
            }
        }
    }
    var startTime: TimeInterval = 0
    
    var endTimeStr: String?{
        didSet {
            if let string = self.endTimeStr {
                self.endTime = Date.second(with: string)
            }
        }
    }
    var endTime: TimeInterval = 0
    
    var lrc: String?
}
