//
//  LFListCell.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFListCell: UITableViewCell {

    @IBOutlet fileprivate weak var iconView: UIImageView!
    @IBOutlet fileprivate weak var musicNameL: UILabel!
    @IBOutlet fileprivate weak var signarNameL: UILabel!
    
    var musicM: LFMusicModel? {
        didSet {
            self.iconView.image = UIImage(named: (self.musicM?.singerIcon)!)
            self.musicNameL.text = self.musicM?.name
            self.signarNameL.text = self.musicM?.singer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconView.layer.cornerRadius = self.iconView.frame.width*0.5
        self.iconView.layer.masksToBounds = true
    }
    
    public static func listCell(with tableView: UITableView) -> LFListCell {
        let lfListCell_id = "LFListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: lfListCell_id) as? LFListCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("LFListCell", owner: nil, options: nil)?.last as? LFListCell
        }
        return cell!
    }
}
