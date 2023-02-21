//
//  HTMLVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import UIKit

class HTMLVC: BaseVC {
    
    init(_ item: HTMLItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var item: HTMLItem = .privacy

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_back"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = .gray
    }

}

extension HTMLVC {
    
    override func setupUI() {
        super.setupUI()
        
        let textView = UITextView()
        textView.textColor = UIColor(named: "#333333")
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = item.desc
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-10)
        }
    }
    
}

enum HTMLItem {
    case privacy, terms
    
    var title: String {
        switch self {
        case .privacy:
            return "Privacy Policy"
        case .terms:
            return "Terms of Use"
        }
    }
    
    var desc: String {
        switch self {
        case .privacy:
            return """
The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
"""
        case .terms:
            return """
The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
"""
        }
    }
}
