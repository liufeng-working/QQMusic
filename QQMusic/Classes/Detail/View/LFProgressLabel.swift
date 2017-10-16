//
//  LFProgressLabel.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFProgressLabel: UILabel {
    
    public var progress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.red.set()
        
        let fileR = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width*self.progress, height: rect.height)
        UIRectFillUsingBlendMode(fileR, CGBlendMode.sourceIn)
    }
}
