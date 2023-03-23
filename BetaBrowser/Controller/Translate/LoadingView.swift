//
//  LoadingView.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func present(from vc: UIViewController) {
        let view = LoadingView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        vc.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(vc.view)
        }
    }
    
    class func dismiss(with vc: UIViewController?) {
        let view: UIView? = vc?.view.subviews.filter {
            $0 is LoadingView
        }.first
        UIView.animate(withDuration: 0.25, animations: {
            view?.alpha = 0
        }, completion: {_ in
            view?.removeFromSuperview()
        })
    }
    
    func setupUI() {
        let contentView = UIView()
        contentView.backgroundColor = .black
        contentView.cornerRadius = 8
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.height.equalTo(112)
            make.width.equalTo(172)
        }
        
        let iconView = UIImageView(image: UIImage(named: "translate_loading"))
        contentView.addSubview(iconView)
        
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 3.0
        animation.repeatCount = Float(Int.max)
        animation.isRemovedOnCompletion = false
        animation.toValue = 2 * Double.pi
        iconView.layer.add(animation, forKey: "dd")
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(18)
        }
        
        let label = UILabel()
        label.textColor = .white
        label.text = "loading..."
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(iconView.snp.bottom).offset(20)
        }
        
    }
}
