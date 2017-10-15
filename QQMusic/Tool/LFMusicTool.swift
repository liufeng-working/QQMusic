//
//  LFMusicTool.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFMusicTool: NSObject {
    public static let shareMusicTool = LFMusicTool()
    
    public var musicMs = [LFMusicModel]()
    
    public var detailM: LFDetailModel {
        let detailM = LFDetailModel()
        detailM.musicM = self.musicMs[self.currentIndex]
        detailM.costTime = LFAudio.shareAudio.currentTime
        detailM.totleTime = LFAudio.shareAudio.totleTime
        detailM.isPlaying = LFAudio.shareAudio.isPlaying
        return detailM
    }
    
    private var currentIndex = -1 {
        didSet {
            if self.currentIndex < 0 {
                self.currentIndex = self.musicMs.count - 1
            }
            
            if self.currentIndex > self.musicMs.count - 1 {
                self.currentIndex = 0
            }
        }
    }
}

extension LFMusicTool {
    public func play(musicM: LFMusicModel) {
        LFAudio.shareAudio.play(name: musicM.filename!)
        self.currentIndex = self.musicMs.index(of: musicM)!
    }
    
    public func playCurrent() {
        LFAudio.shareAudio.play(name: self.musicMs[self.currentIndex].filename!)
    }
    
    public func pause() {
        LFAudio.shareAudio.pause()
    }
    
    public func previous() {
        self.currentIndex -= 1
        let musicM = self.musicMs[self.currentIndex]
        LFAudio.shareAudio.play(name: musicM.filename!)
    }
    
    public func next() {
        self.currentIndex += 1
        let musicM = self.musicMs[self.currentIndex]
        LFAudio.shareAudio.play(name: musicM.filename!)
    }
}
