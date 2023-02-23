//
//  CleanVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import UIKit
import Lottie

class CleanVC: BaseVC {
    
    var handle: (()->Void)? = nil
    var progress = 0.0
    var launchTimer: Timer?
    var adTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adLoading()
    }

}

extension CleanVC {
    
    override func setupUI() {
        super.setupUI()
        let label = UILabel()
        label.text = "loading..."
        label.textColor = UIColor(named: "#333333")
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(80)
        }
        
        let animationView = LottieAnimationView()
        animationView.loopMode = .loop
        animationView.animation = LottieAnimation.named("data")
        animationView.play()
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
    }
    
}

extension CleanVC {
    
    func adLoading() {
            if launchTimer != nil {
                launchTimer?.invalidate()
                launchTimer = nil
            }
            
            if adTimer != nil {
                adTimer?.invalidate()
                adTimer = nil
            }
            
            var duration = 2.5 / 0.4
            var isADStartLoaded = false
            self.progress = 0
        debugPrint(progress)
            
            launchTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                self.progress += 0.01 / duration
                if self.progress > 1.0 {
                    timer.invalidate()
                    if AppUtil.shared.enterbackground {
                        self.handle?()
                    } else {
                        GADUtil.share.show(.interstitial, from: self) { _ in
                            BrowserUtil.shared.clean(from: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.dismiss(animated: true) {
                                    self.handle?()
                                }
                            }
                        }
                    }
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
            
            GADUtil.share.load(.interstitial)
            GADUtil.share.load(.native)
        }
    
}
