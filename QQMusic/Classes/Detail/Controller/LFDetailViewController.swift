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
    @IBOutlet fileprivate weak var lrcL: LFProgressLabel!
    @IBOutlet fileprivate weak var lrcScrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var bottomView: UIView!
    @IBOutlet fileprivate weak var startTimeL: UILabel!
    @IBOutlet fileprivate weak var progressView: UISlider!
    @IBOutlet fileprivate weak var endTimeL: UILabel!
    @IBOutlet fileprivate weak var playOrPauseBtn: UIButton!
    
    lazy var lrcVC: LFLrcViewController = {
        let lrcVC = LFLrcViewController()
        self.lrcScrollView.addSubview(lrcVC.view)
        return lrcVC
    }()
    
    var timer: Timer?
    
    var link: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupOnce()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addTimer()
        self.addLink()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeTimer()
        self.removeLink()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLrcViewFrame()
        self.setupIconViewCornerRadius()
    }
}

//MARK: - UI
extension LFDetailViewController {
    
    private func setupLrcViewFrame() {
        let frame = self.lrcScrollView.bounds
        self.lrcVC.view.frame = frame
        self.lrcVC.view.frame.origin.x = frame.width
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
        
        self.endTimeL.text = detailM.totleTimeStr
        
        self.addIconViewAnimation()
        if LFMusicTool.shareMusicTool.detailM.isPlaying {
            self.resumeIconViewAnimation()
        }else {
            self.pauseIconViewAnimation()
        }
        
        LFDataTool.lrcModels(lrcName: detailM.musicM!.lrcname!) {(lrcMs: [LFLrcModel]) in
            self.lrcVC.lrcMs = lrcMs
        }
        
        LFMusicTool.shareMusicTool.playCompletion = {[unowned self] (url: URL) in
            self.forwardMusic()
        }
    }
    
    private func setupMore() {
        let detailM = LFMusicTool.shareMusicTool.detailM
        
        self.lrcL.text = nil
    
        self.startTimeL.text = detailM.costTimeStr
        self.progressView.value = Float(detailM.costTime/detailM.totleTime)
        self.playOrPauseBtn.isSelected = !LFMusicTool.shareMusicTool.detailM.isPlaying
        
        LFMusicTool.shareMusicTool.setupLockInfo()
    }
}

//MARK: - 私有方法
extension LFDetailViewController {
    private func addTimer() {
        if self.timer == nil {
            self.timer = Timer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    private func removeTimer() {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    private func addLink() {
        if self.link == nil {
            self.link = CADisplayLink(target: self, selector: #selector(handleLink))
            link?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        }
    }
    
    private func removeLink() {
        if self.link != nil {
            self.link!.invalidate()
            self.link = nil
        }
    }
    
    private func addIconViewAnimation() {
        self.iconView.layer.removeAnimation(forKey: "rotation")
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Float.pi*2
        rotation.repeatCount = MAXFLOAT
        rotation.duration = 30
        rotation.isRemovedOnCompletion = false
        self.iconView.layer.add(rotation, forKey: "rotation")
    }
    
    private func pauseIconViewAnimation() {
        self.iconView.layer.pauseAnimation()
    }
    
    private func resumeIconViewAnimation() {
        self.iconView.layer.resumeAnimation()
    }
    
    private func seek(with progress: Float) {
        let totleT = LFMusicTool.shareMusicTool.detailM.totleTime
        let costT = totleT*TimeInterval(progress)
        LFMusicTool.shareMusicTool.seek(toTime: costT)
    }
}

//MARK: - 事件
extension LFDetailViewController {
    
    @IBAction fileprivate func backMusic() {
        
        LFMusicTool.shareMusicTool.previous()
        self.setupOnce()
    }
    
    @IBAction fileprivate func playAndPause(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if LFMusicTool.shareMusicTool.detailM.isPlaying {
            LFMusicTool.shareMusicTool.pause()
            self.pauseIconViewAnimation()
            self.removeLink()
            self.removeTimer()
        }else {
            LFMusicTool.shareMusicTool.playCurrent()
            self.resumeIconViewAnimation()
            self.addLink()
            self.addTimer()
        }
    }
    
    @IBAction fileprivate func forwardMusic() {
        LFMusicTool.shareMusicTool.next()
        self.setupOnce()
    }
    
    @IBAction private func slideDidChangeValue(sender: UISlider) {
        self.seek(with: Float(sender.value))
    }
    
    @IBAction private func tap(_ sender: UITapGestureRecognizer) {
        let value = sender.location(in: sender.view).x/sender.view!.frame.width
        self.progressView.value = Float(value)
        self.seek(with: Float(value))
    }
    
    @objc private func handleTimer() {
        self.setupMore()
    }
    
    @objc private func handleLink() {
        let currentTime = LFMusicTool.shareMusicTool.detailM.costTime
        let lrcMs = self.lrcVC.lrcMs
        let result = LFDataTool.currentLrcModel(currentTime: currentTime, lrcMs: lrcMs)
        self.lrcL.text = result.lrcM?.lrc
        self.lrcVC.scrollToRow = result.row
        
        if let lrcM = result.lrcM {
            
            let progress = CGFloat((currentTime - lrcM.startTime)/(lrcM.endTime - lrcM.startTime))
            self.lrcL.progress = progress
            self.lrcVC.progress = progress
        }
    }
}

//MARK: - 远程事件
extension LFDetailViewController {
    override func remoteControlReceived(with event: UIEvent?) {
        guard let type = event?.subtype else {
            return
        }
        
        switch type {
        case .remoteControlPlay:
            LFMusicTool.shareMusicTool.playCurrent()
        case .remoteControlPause:
            LFMusicTool.shareMusicTool.pause()
        case .remoteControlNextTrack:
            LFMusicTool.shareMusicTool.next()
        case .remoteControlPreviousTrack:
            LFMusicTool.shareMusicTool.previous()
        default: ()
        }
        
        self.setupOnce()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        LFMusicTool.shareMusicTool.next()
        self.setupOnce()
    }
}

//MARK: - UIScrollViewDelegate
extension LFDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x/scrollView.frame.width
        self.middleView.alpha = alpha
    }
}
