//
//  LFDetailViewController.swift
//  QQMusic
//
//  Created by 刘丰 on 2017/10/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

import UIKit

class LFDetailViewController: UIViewController {
    
    @IBOutlet fileprivate weak var backView: UIImageView!
    
    @IBOutlet fileprivate weak var topView: UIView!
    @IBOutlet fileprivate weak var fileNameL: UILabel!
    @IBOutlet fileprivate weak var singerNameL: UILabel!
    
    @IBOutlet fileprivate weak var middleView: UIView!
    @IBOutlet fileprivate weak var iconView: UIImageView!
    @IBOutlet fileprivate weak var lrcL: UILabel!
    @IBOutlet fileprivate weak var lrcScrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var bottomView: UIView!
    @IBOutlet fileprivate weak var startTimeL: UILabel!
    @IBOutlet fileprivate weak var progressView: UISlider!
    @IBOutlet fileprivate weak var endTimeL: UILabel!
    
    lazy var lrcView: UIView = {
        let lrcView = UIView()
        lrcView.backgroundColor = UIColor.red
        self.lrcScrollView.addSubview(lrcView)
        return lrcView
    }()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupOnce()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addTime()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeTime()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.middleView.layoutIfNeeded()
        self.setupLrcViewFrame()
        self.setupIconViewCornerRadius()
    }
}

//MARK: - UI
extension LFDetailViewController {
    
    private func setupLrcViewFrame() {
        let frame = self.lrcScrollView.bounds
        self.lrcView.frame = frame
        self.lrcView.frame.origin.x = frame.width
        self.lrcScrollView.contentSize = CGSize(width: frame.width*2, height: 0)
    }
    
    private func setupIconViewCornerRadius() {
        self.iconView.layer.cornerRadius = self.iconView.frame.width*0.5
        self.iconView.layer.masksToBounds = true
    }
    
    private func setupOnce() {
        
        let detailM = LFMusicTool.shareMusicTool.detailM
        
        self.backView.image = UIImage(named: detailM.musicM!.icon!)
        
        self.fileNameL.text = detailM.musicM?.name
        self.singerNameL.text = detailM.musicM?.singer
        
        self.iconView.image = UIImage(named: detailM.musicM!.icon!)
        
        self.endTimeL.text = "\(detailM.totleTime)"
    }
    
    private func setupMore() {
        let detailM = LFMusicTool.shareMusicTool.detailM
        
        self.lrcL.text = nil
    
        self.startTimeL.text = "\(detailM.costTime)"
        self.progressView.value = Float(detailM.costTime/detailM.totleTime)
    }
}

//MARK: - 私有方法
extension LFDetailViewController {
    private func addTime() {
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    private func removeTime() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

//MARK: - 事件
extension LFDetailViewController {
    
    @IBAction fileprivate func backMusic(sender: UIButton) {
        
        LFMusicTool.shareMusicTool.previous()
        self.setupOnce()
    }
    
    @IBAction fileprivate func playAndPause(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            LFMusicTool.shareMusicTool.pause()
        }else {
            LFMusicTool.shareMusicTool.playCurrent()
        }
    }
    
    @IBAction fileprivate func forwardMusic(sender: UIButton) {
        
        LFMusicTool.shareMusicTool.next()
        self.setupOnce()
    }
    
    @objc private func handleTimer() {
        self.setupMore()
    }
}
