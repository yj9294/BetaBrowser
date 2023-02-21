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

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            BrowserUtil.shared.clean(from: self)
            self.dismiss(animated: true) {
                self.handle?()
            }
        }
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
