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
        view.backgroundColor = .black
        let bg = UIImageView(image: UIImage(named: "launch_bg"))
        view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
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
