//
//  OCRResultVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit
import MobileCoreServices

class OCRResultVC: BaseVC {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var result: String? = nil
    
    var image: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OCR"
        textLabel.text = result
        imageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }
    
    func initNavigationBar() {
        let appearce = UINavigationBarAppearance()
        appearce.backgroundColor = .clear
        appearce.shadowImage = UIImage()
        appearce.shadowColor = .clear
        appearce.configureWithTransparentBackground()
        navigationController?.navigationBar.compactAppearance = appearce
        navigationController?.navigationBar.standardAppearance = appearce
        navigationController?.navigationBar.scrollEdgeAppearance = appearce
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_back"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = AppUtil.shared.darkModel ? .white : .white
    }

}

extension OCRResultVC {
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(64)
            make.left.equalTo(view).offset(38)
            make.right.equalTo(view).offset(-38)
            make.bottom.equalTo(view).offset(-40)
        }
        
        scrollView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let actionView = UIView()
        actionView.cornerRadius = 8
        actionView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.addSubview(actionView)
        actionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(304)
            make.height.equalTo(50)
            make.bottom.equalTo(view.snp_bottomMargin).offset(-28)
        }
        
        let copyButton = UIButton()
        copyButton.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        copyButton.setTitle("Copy", for: .normal)
        copyButton.setTitleColor(.white, for: .normal)
        actionView.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let lineView = UIView()
        lineView.backgroundColor = .white
        actionView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        let retryButton = UIButton()
        retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        actionView.addSubview(retryButton)
        retryButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(copyButton.snp.right)
            make.width.equalTo(copyButton.snp.width)
        }
    }
    
    @objc func retryAction() {
        self.backAction()
    }
    
    @objc func copyAction() {
        UIPasteboard.general.setValue(result ?? "", forPasteboardType: kUTTypePlainText as String)
        self.alert("copy_successful".localized())
        Task {
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                self.backAction()
            }
        }
    }
    
}

