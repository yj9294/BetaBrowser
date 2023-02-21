//
//  AlertController.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import UIKit

class AlertController: UIViewController {
    
    var handle:(()->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension AlertController {
    
    func setupUI() {
        self.view.backgroundColor = .clear
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.cornerRadius = 12
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(34)
            make.right.equalTo(view).offset(-34)
        }
        
        let icon = UIImageView(image: UIImage(named: "clean_icon"))
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(20)
        }
        
        let label = UILabel()
        label.text = "Close Tabs and Clear Data"
        label.textColor = UIColor(named: "#333333")
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(14)
            make.centerX.equalTo(view)
        }
        
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        cancel.cornerRadius = 22
        cancel.backgroundColor = UIColor(named: "#E7E7E7")
        cancel.setTitleColor(.white, for: .normal)
        contentView.addSubview(cancel)
        cancel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(18)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        let confirm = UIButton()
        confirm.setTitle("Confirm", for: .normal)
        confirm.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        confirm.cornerRadius = 22
        confirm.backgroundColor = UIColor(named: "#28CF7A")
        confirm.setTitleColor(.white, for: .normal)
        contentView.addSubview(confirm)
        confirm.snp.makeConstraints { make in
            make.left.equalTo(cancel.snp.right).offset(16)
            make.right.equalTo(contentView).offset(-18)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.width.equalTo(cancel.snp.width)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    
    @objc func confirmAction() {
        dismiss(animated: true) {
            self.handle?()
        }
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
}
