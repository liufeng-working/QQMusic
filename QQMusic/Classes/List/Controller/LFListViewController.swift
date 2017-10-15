//
//  LFListViewController.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFListViewController: UITableViewController {
    
    fileprivate var musicMs: [LFMusicModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        LFDataTool.musicModels { (musicMs: [LFMusicModel]) in
            self.musicMs = musicMs
            LFMusicTool.shareMusicTool.musicMs = musicMs
        }
    }
}

//MARK: - UI
extension LFListViewController {
    
    fileprivate func setupUI() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "QQListBack"))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
}

//MARK: - UITableViewDataSource
extension LFListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicMs.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = LFListCell.listCell(with: tableView)
         cell.musicM = self.musicMs[indexPath.row]
         return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let musicM = self.musicMs[indexPath.row]
        LFMusicTool.shareMusicTool.play(musicM: musicM)
        self.performSegue(withIdentifier: "LFDetailViewController", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
