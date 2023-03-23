//
//  TextTranslateVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit

class TextTranslateVC: BaseVC {
    
    lazy var sourceButton: UIButton = {
        let button = UIButton()
        button.setTitle("English      ···", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor(named: "#333333"), for: .normal)
        button.addTarget(self, action: #selector(sourceAction), for: .touchUpInside)
        return button
    }()
    
    lazy var targetButton: UIButton = {
        let button = UIButton()
        button.setTitle("English      ···", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(targetAction), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "#333333"), for: .normal)
        return button
    }()
    
    lazy var translateView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor(named: "#394468")
        view.cornerRadius = 12
        view.delegate = self
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .white
        view.contentInset = UIEdgeInsets(top: 15, left: 18, bottom: 20, right: 20)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "tab_close"), for: .normal)
        button.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var placeholder: UILabel = {
        let label = UILabel()
        label.text = "Enter text here"
        label.textColor = UIColor(white: 1, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Text"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_back"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = AppUtil.shared.darkModel ? .white : UIColor(named: "#333333")
        sourceButton.setTitle(ProfileUtil.share.textSourceLanguage.language + "  ···", for: .normal)
        targetButton.setTitle(ProfileUtil.share.textTargetLanguage.language + "  ···", for: .normal)

    }
    
}

extension TextTranslateVC {
    
    override func setupUI() {
        super.setupUI()
        
        let source = UIView()
        source.backgroundColor = .white
        source.cornerRadius = 25
        source.layer.borderColor = UIColor(named: "#333333")?.cgColor
        source.layer.borderWidth = 1
        view.addSubview(source)
        source.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view).offset(16)
            make.width.equalTo(136)
            make.height.equalTo(50)
        }
        
        source.addSubview(sourceButton)
        sourceButton.snp.makeConstraints { make in
            make.center.equalTo(source)
        }
        
        let icon = UIImageView(image: UIImage(named: "text_translate_translate"))
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exchangeAction)))
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(source)
            make.centerX.equalTo(view)
        }
        
        let target = UIView()
        target.backgroundColor = .white
        target.cornerRadius = 25
        target.layer.borderColor = UIColor(named: "#333333")?.cgColor
        target.layer.borderWidth = 1
        view.addSubview(target)
        target.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.right.equalTo(view).offset(-16)
            make.width.equalTo(136)
            make.height.equalTo(50)
        }
        
        target.addSubview(targetButton)
        targetButton.snp.makeConstraints { make in
            make.center.equalTo(target)
        }
        
        view.addSubview(translateView)
        translateView.snp.makeConstraints { make in
            make.top.equalTo(target.snp.bottom).offset(20)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.height.equalTo(240)
        }
        
        view.addSubview(placeholder)
        placeholder.snp.makeConstraints { make in
            make.top.equalTo(translateView).offset(20)
            make.left.equalTo(translateView).offset(20)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(translateView).offset(21)
            make.right.equalTo(translateView).offset(-13)
        }
        
        let button = UIButton()
        button.setTitle("Translate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(translateAction), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "text_translate_bg"), for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalTo(translateView.snp.bottom)
            make.centerX.equalTo(view)
            make.width.equalTo(216)
            make.height.equalTo(50)
        }
    }
    
}


extension TextTranslateVC {
    
    @objc func translateAction() {
//        FirebaseManager.logEvent(name: .allBegin, params: ["now": "1"])
//        if NetworkUtil.shared.isConnected {
//            FirebaseManager.logEvent(name: .translateClick)
//        }
        
        LoadingView.present(from: self)
        let source = ProfileUtil.share.textSourceLanguage
        let target = ProfileUtil.share.textTargetLanguage
        self.view.endEditing(true)
        TranslateUtil.share.isOCR = false
        TranslateUtil.share.translate(text: self.translateView.text, source: source, target: target) { [weak self] isSuccess, result in
            LoadingView.dismiss(with: self)
            guard let self = self else { return }
            if AppUtil.shared.enterbackground {
                return
            }
            if !isSuccess {
                self.alert(result)
                return
            }
//            if source.language == target.language {
//                FirebaseManager.logEvent(name: .translateSuccess, params: ["now": "3"])
//            } else if TranslateManager.share.isWebTranslate {
//                FirebaseManager.logEvent(name: .translateSuccess, params: ["now": "2"])
//            } else {
//                FirebaseManager.logEvent(name: .translateSuccess, params: ["now": "1"])
//            }
            ProfileUtil.share.translateText = self.translateView.text
            self.cleanAction()
//            FirebaseManager.logEvent(name: .resultShow)
            let vc = TextResultVC()
            vc.result = result
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func exchangeAction() {
        let tp = ProfileUtil.share.textSourceLanguage
        ProfileUtil.share.textSourceLanguage = ProfileUtil.share.textTargetLanguage
        ProfileUtil.share.textTargetLanguage = tp
        
        sourceButton.setTitle(ProfileUtil.share.textSourceLanguage.language + "  ···", for: .normal)
        targetButton.setTitle(ProfileUtil.share.textTargetLanguage.language + "  ···", for: .normal)
    }
    
    @objc func sourceAction() {
        
        let datasource:[Language] = ProfileUtil.share.sourceDatasource.flatMap{
            $0
        }
        
        let vc = CountryListVC()
        vc.datasource = datasource
        vc.language = ProfileUtil.share.textSourceLanguage
        vc.completion = { lan in
            ProfileUtil.share.textSourceLanguage = lan
            self.sourceButton.setTitle(lan.language + "  ···", for: .normal)
        }
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func targetAction() {
        let datasource:[Language] = ProfileUtil.share.targetDatasource.flatMap{
            $0
        }
        let vc = CountryListVC()
        vc.datasource = datasource
        vc.language = ProfileUtil.share.textTargetLanguage
        vc.completion = { lan in
            ProfileUtil.share.textTargetLanguage = lan
            self.targetButton.setTitle(lan.language + "  ···", for: .normal)
        }
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func cleanAction() {
        translateView.text = ""
        placeholder.isHidden = false
        closeButton.isHidden = true
    }
    
}

extension TextTranslateVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = textView.text.count > 0
        textView.text = String(textView.text.prefix(2000))
    }
    
}
