//
//  LFMusicTool.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit
import MediaPlayer

class LFMusicTool: NSObject {
    public static let shareMusicTool = LFMusicTool()
    
    public var musicMs = [LFMusicModel]()
    
    private let privateDetailM = LFDetailModel()
    public var detailM: LFDetailModel {
        self.privateDetailM.musicM = self.musicMs[self.currentIndex]
        self.privateDetailM.costTime = LFAudio.shareAudio.currentTime
        self.privateDetailM.totleTime = LFAudio.shareAudio.totleTime
        self.privateDetailM.isPlaying = LFAudio.shareAudio.isPlaying
        return privateDetailM
    }
    
    public var playFilure: ((_ errorReason: String) -> ())? {
        didSet {
            LFAudio.shareAudio.playFilure = {(errorReason: String) in
                self.playFilure!(errorReason)
            }
        }
    }
    
    public var playCompletion: ((_ url: URL) -> ())? {
        didSet {
            LFAudio.shareAudio.playCompletion = {(url: URL) in
                self.playCompletion!(url)
            }
        }
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
    
    private var artwork = MPMediaItemArtwork(image: UIImage(named: "LaunchImage")!)
    
    private var lastLrc = ""
}

extension LFMusicTool {
    public func play(musicM: LFMusicModel) {
        LFAudio.shareAudio.play(name: musicM.filename!)
        self.currentIndex = self.musicMs.index(of: musicM)!
    }
    
    public func seek(toTime time: TimeInterval) {
        LFAudio.shareAudio.seek(toTime: time)
    }
    
    public func playCurrent() {
        LFAudio.shareAudio.stop()
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
    
    public func setupLockInfo() {
        if UIApplication.shared.applicationState != UIApplicationState.background {
            return
        }
        
        //锁屏中心
        let center = MPNowPlayingInfoCenter.default()
        
        let musicName = self.detailM.musicM?.name ?? ""
        let signerName = self.detailM.musicM?.singer ?? ""
        let costTime = self.detailM.costTime
        let totleTime = self.detailM.totleTime
        
        if let image = UIImage(named: self.detailM.musicM?.icon ?? "")
        {
            let currentTime = self.detailM.costTime
            LFDataTool.lrcModels(lrcName: (self.detailM.musicM?.lrcname)!, result: { (lrcMs: [LFLrcModel]) in
                if let lrcM = LFDataTool.currentLrcModel(currentTime: currentTime, lrcMs: lrcMs).lrcM,
                    let lrc = lrcM.lrc as NSString?,
                    let l = lrcM.lrc,
                    self.lastLrc != l {
                    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                    UIGraphicsBeginImageContext(rect.size)
                    image.draw(in: rect)
                    let font = UIFont.systemFont(ofSize: 20)
                    let style = NSMutableParagraphStyle()
                    style.alignment = NSTextAlignment.center
                    let att = [
                        NSAttributedStringKey.foregroundColor: UIColor.white,
                        NSAttributedStringKey.font: font,
                        NSAttributedStringKey.paragraphStyle: style]
                    
                    lrc.draw(in: CGRect(x: 0, y: 10, width: rect.width, height: font.lineHeight), withAttributes: att)
                    let newImg = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.artwork = MPMediaItemArtwork(image: newImg)
                    self.lastLrc = l
                }
            })
        }
        
        //给锁屏中心赋值
        center.nowPlayingInfo = [
            MPMediaItemPropertyAlbumTitle: musicName,
            MPMediaItemPropertyArtist: signerName,
            MPMediaItemPropertyPlaybackDuration: totleTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime,
            MPMediaItemPropertyArtwork: self.artwork
        ]
        
        //接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
}
