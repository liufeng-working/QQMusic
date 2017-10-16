//
//  LFLrcViewController.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFLrcViewController: UITableViewController {
    
    public var lrcMs = [LFLrcModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public var scrollToRow = 0 {
        didSet {
            if oldValue == self.scrollToRow {
                return
            }
            
            if let indexPath = self.tableView.indexPathsForVisibleRows {
                self.tableView.reloadRows(at: indexPath, with: UITableViewRowAnimation.fade)
            }
            
            self.tableView.scrollToRow(at: IndexPath(row: self.scrollToRow, section: 0), at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    public var progress: CGFloat = 0.0 {
        didSet {
            let cell = self.tableView.cellForRow(at: IndexPath(row: self.scrollToRow, section: 0)) as? LFLrcCell
            cell?.progress = self.progress
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let top = self.tableView.frame.height*0.5
        self.tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: top, right: 0)
    }
}

//MARK: - UI
extension LFLrcViewController {
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.allowsSelection = false
    }
}

extension LFLrcViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lrcMs.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LFLrcCell.lrcCell(with: tableView)
        cell.lrcM = self.lrcMs[indexPath.row]
        
        if indexPath.row == self.scrollToRow {
            cell.progress = self.progress
        }else {
            cell.progress = 0.0
        }
        return cell
     }
}
