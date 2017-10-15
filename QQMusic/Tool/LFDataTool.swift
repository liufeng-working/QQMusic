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
}
