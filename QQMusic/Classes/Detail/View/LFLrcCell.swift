//
//  LFLrcCell.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFLrcCell: UITableViewCell {
    
    @IBOutlet private weak var lrcL: LFProgressLabel!
    
    var lrcM: LFLrcModel? {
        didSet {
            self.lrcL.text = lrcM?.lrc
        }
    }
    
    var progress: CGFloat = 0.0 {
        didSet {
            self.lrcL.progress = self.progress
        }
    }
    
    
    public static func lrcCell(with tableView: UITableView) -> LFLrcCell {
        let lfLrcCell_id = "LFLrcCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: lfLrcCell_id) as? LFLrcCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("LFLrcCell", owner: nil, options: nil)?.first as? LFLrcCell
        }
        return cell!
    }
}
