//
//  BaseVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/14.
//

import UIKit
import SnapKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private lazy  var bg: UIImageView = {
        let bg = UIImageView(image: UIImage(named: "launch_bg"))
        return bg
    }()
    
    var width: CGFloat {
        view.window?.frame.size.width ?? 100
    }
    
    var height: CGFloat {
        view.window?.frame.size.height ?? 100
    }
    
    deinit{
        debugPrint("---------\(self) deinit!!!--------")
    }

}

extension BaseVC {
    
    @objc func setupUI() {
        if AppUtil.shared.darkModel {
            view.backgroundColor = .black
        } else {
            let bg = UIImageView(image: UIImage(named: "launch_bg"))
            view.addSubview(bg)
            bg.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(view)
            }
            view.backgroundColor = UIColor(named: "#6EEBC3")
        }
        
        NotificationCenter.default.addObserver(forName: .darkModelDidUpdate, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.view.backgroundColor = AppUtil.shared.darkModel ? .black : .white
            if !AppUtil.shared.darkModel {
                self.view.insertSubview(self.bg, at: 0)
                self.bg.snp.makeConstraints { make in
                    make.top.left.right.bottom.equalTo(self.view)
                }
            } else {
                self.bg.removeFromSuperview()
            }
        }
    }
    
    @objc func backAction() {
        if let vc = self.navigationController {
            if vc.viewControllers.count <= 1 {
                self.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
}
