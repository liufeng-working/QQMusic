//
//  LFAudio.swift
//
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit
import AVFoundation

class LFAudio: NSObject {
    
    public static let shareAudio = LFAudio()
    
    public var playFilure: ((_ errorReason: String) -> ())?
    public var playCompletion: ((_ url: URL) -> ())?
    
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
            self.audioPlayer?.play()
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: pathUrl)
            self.audioPlayer!.delegate = self
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        }catch {
            self.playFilure?("初始化音乐播放器失败")
            return
        }
    }
    
    /// 暂停播放音频
    public func pause() {
        self.audioPlayer?.pause()
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
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try? audioSession.setActive(true)
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
