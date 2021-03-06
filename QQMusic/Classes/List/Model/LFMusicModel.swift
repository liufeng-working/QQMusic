//
//  LFMusicModel.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

@objcMembers
class LFMusicModel: NSObject {
    
    /// 歌曲名称
    var name: String?
    
    /// 歌曲文件名称
    var filename: String?
    
    /// 歌词文件名称
    var lrcname: String?
    
    /// 歌手名称
    var singer: String?
    
    /// 歌手头像
    var singerIcon: String?
    
    /// 专辑图片
    var icon: String?
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        
        self.setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
