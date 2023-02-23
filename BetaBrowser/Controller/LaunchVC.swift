//
//  LaunchVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/14.
//

import UIKit

class LaunchVC: BaseVC {
    
    private var launchTimer: Timer?
    private var adTimer: Timer?
    private var progress = 0.0

    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = UIColor.white
        view.tintColor = UIColor(named: "#6EEBC3")
        view.cornerRadius = 2.5
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension LaunchVC {
    
    override func setupUI() {
        super.setupUI()
        let icon = UIImageView(image: UIImage(named: "launch_icon"))
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp_topMargin).offset(130)
        }
        
        let title = UIImageView(image: UIImage(named: "launch_title"))
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(icon.snp.bottom).offset(14)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(80)
            make.right.equalTo(view.snp.right).offset(-80)
            make.bottom.equalTo(view.snp_bottomMargin).offset(-50)
        }
    }
    
    
    func launching() {
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
        
        self.progressView.progress = 0.0
        if launchTimer != nil {
            launchTimer?.invalidate()
            launchTimer = nil
        }
        
        if adTimer != nil {
            adTimer?.invalidate()
            adTimer = nil
        }
        
        var duration = 2.5 / 0.6
        var isADStartLoaded = false
        self.progress = 0
        
        launchTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.progress += 0.01 / duration
            if self.progress > 1.0 {
                timer.invalidate()
                GADUtil.share.show(.interstitial) { _ in
                    if self.progress > 1.0 {
                        AppUtil.shared.root?.launched()
                    }
                }
            } else {
                self.progressView.progress = Float(self.progress)
            }
            if isADStartLoaded, GADUtil.share.isLoaded(.interstitial) {
                isADStartLoaded = false
                duration = 0.1
            }
        })
        
        adTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { timer in
            timer.invalidate()
            duration = 16
            isADStartLoaded = true
        })
        
    }
    
}
