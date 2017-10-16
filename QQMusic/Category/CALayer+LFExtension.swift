//
//  CALayer+LFExtension.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

extension CALayer {
    public func pauseAnimation() {
        let pauseTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pauseTime
    }
    
    public func resumeAnimation() {
        let pauseTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        self.beginTime = timeSincePause
    }
}
