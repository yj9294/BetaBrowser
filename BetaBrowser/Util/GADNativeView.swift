//
//  GADNativeView.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/21.
//

import Foundation
import SnapKit

import GoogleMobileAds

class GADNativeView: GADNativeAdView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var placeholder: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ad_placeholder"))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "#525050")
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "#858585")
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    lazy var install: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "#26D8FF")
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.isHidden = true
        return button
    }()
    lazy var adTag: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "home_ad")
        label.isHidden = true
        return label
    }()
    
    func setupUI() {
        
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        addSubview(placeholder)
        placeholder.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.left.equalTo(self).offset(12)
            make.width.height.equalTo(40)
        }
        addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(self).offset(14)
            make.left.equalTo(icon.snp.right).offset(8)
            make.right.equalTo(self).offset(-48)
        }
        addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.left.equalTo(icon.snp.right).offset(8)
            make.right.equalTo(self).offset(-12)
        }
        addSubview(adTag)
        adTag.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.left.equalTo(title.snp.right).offset(8)
        }
        addSubview(install)
        install.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(12)
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.bottom.equalTo(self).offset(-12)
            make.height.equalTo(36)
        }
    }

    override var nativeAd: GADNativeAd? {
        didSet {
            if let nativeAd = nativeAd {
                
                self.icon.isHidden = false
                self.title.isHidden = false
                self.subTitle.isHidden = false
                self.install.isHidden = false
                self.adTag.isHidden = false
                self.placeholder.isHidden = true
                
                if let image = nativeAd.images?.first?.image {
                    self.icon.image =  image
                }
                self.title.text = nativeAd.headline
                self.subTitle.text = nativeAd.body
                self.install.setTitle(nativeAd.callToAction, for: .normal)
                self.install.setTitleColor(.white, for: .normal)
            } else {
                self.icon.isHidden = true
                self.title.isHidden = true
                self.subTitle.isHidden = true
                self.install.isHidden = true
                self.adTag.isHidden = true
                self.placeholder.isHidden = false
            }
            
            callToActionView = install
            headlineView = title
            bodyView = subTitle
            advertiserView = adTag
            iconView = icon
        }
    }
    
}
