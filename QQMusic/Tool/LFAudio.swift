//
//  LFAudio.swift
//
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//  播放音频的工具（本地音频）

import UIKit
import AVFoundation

@objcMembers
class LFAudio: NSObject {
    
    public static let shareAudio = LFAudio()
    
    /// 播放结束的回调（注意解决循环引用问题，[weak self]）
    public var playCompletion: ((_ url: URL) -> ())?
    
    /// 播放失败的回调（注意解决循环引用问题，[weak self]）
    public var playFilure: ((_ errorReason: String) -> ())?
    
    public var volume: Float = 1 {
        didSet {
            self.audioPlayer?.volume = self.volume
        }
    }
    
    public var currentTime: TimeInterval {
        return self.audioPlayer?.currentTime ?? 0
    }
    
    public var totleTime: TimeInterval {
        return self.audioPlayer?.duration ?? 0
    }
    
    public var isPlaying: Bool {
        return self.audioPlayer?.isPlaying ?? false
    }
    
    fileprivate var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        
        self.playInBack()
    }
}

//MARK: - 公用方法
extension LFAudio {
    
    /// 播放音频
    ///
    /// - Parameters:
    ///   - name: 音频名称
    ///   - subdirectory: 音频所在子bundle名称
    ///   - completion: 播放结束后的回调
    public func play(name: String, subdirectory: String = "") {
        guard let pathUrl = Bundle.main.url(forResource: name, withExtension: nil, subdirectory: subdirectory) else {
            self.playFilure?("音乐路径不正确")
            return
        }
        
        if self.audioPlayer?.url == pathUrl {
            self.resume()
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: pathUrl)
            self.audioPlayer!.delegate = self
            self.audioPlayer!.volume = self.volume
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        }catch {
            self.playFilure?("初始化音乐播放器失败")
            return
        }
    }
    
    /// 播放当前
    public func resume() {
        if !self.isPlaying {
            self.audioPlayer?.play()
        }
    }
    
    /// 暂停播放音频
    public func pause() {
        if self.isPlaying {
            self.audioPlayer?.pause()
        }
    }
    
    /// 结束播放
    public func stop() {
        self.audioPlayer?.currentTime = 0
        self.audioPlayer?.stop()
    }

    /// 播放指定位置
    ///
    /// - Parameter time: 时间点
    public func seek(toTime time: TimeInterval) {
        self.audioPlayer?.currentTime = time
    }
    
    /// 前进几秒
    ///
    /// - Parameter time: 秒数
    public func forward(with second: TimeInterval){
        self.audioPlayer?.currentTime += second
    }
    
    /// 后退几秒
    ///
    /// - Parameter second: 秒数
    public func backward(with second: TimeInterval){
        self.audioPlayer?.currentTime -= second
    }
}

extension LFAudio {
    
    /// 用于播放短音效（一般30秒以内）
    ///
    /// - Parameters:
    ///   - name: 音效名称
    ///   - subdirectory: 音效所在子bundle目录
    ///   - completion: 播放完成后的回调
    public static func playShort(name: String, subdirectory: String = "", completion: ((_ errorString: String?) -> ())? = nil) {
        //获取文件的路径
        guard let pathUrl = Bundle.main.url(forResource: name, withExtension: nil, subdirectory: subdirectory) else {
            completion?("音效路径不正确")
            return
        }
        
        //获取音效文件对应的sourceID
        var sourceID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(pathUrl as CFURL, &sourceID)
        
        //根据id播放音效
        AudioServicesPlaySystemSoundWithCompletion(sourceID) {
            //根据id释放音效
            AudioServicesDisposeSystemSoundID(sourceID)
            completion?(nil)
        }
    }
    
    public static func playShort(name: String, completion: ((_ errorString: String?) -> ())?) {
        self.playShort(name: name, subdirectory: "", completion: completion)
    }
}

//MARK: - 私有方法
extension LFAudio {
    
    fileprivate func playInBack() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        }catch {
            
        }
    }
}

//MARK: - AVAudioPlayerDelegate
extension LFAudio: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playCompletion?(player.url!)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.playFilure?("播放失败")
    }
}
