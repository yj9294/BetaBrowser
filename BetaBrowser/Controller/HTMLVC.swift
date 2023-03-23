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
        self.title = item.rawValue.localized()
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
        textView.textColor = AppUtil.shared.darkModel ? .white : UIColor(named: "#333333")
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = item.desc
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.contentOffset = .zero
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-10)
        }
    }
    
}

enum HTMLItem: String {
    case privacy, terms
    
    var desc: String {
        switch self {
        case .privacy:
            return """
Collection of information
Beta Browser collects the following information about you.
Data about you when you visit our website. This includes, but is not limited to, your IP address, browser type, browser version, the pages of our service you visit, the time and date of your visit and the time spent on those pages.
Diagnostic data, and other diagnostic data
Use and Disclosure of Information
Give you feedback when you contact us by phone or email, etc.
Provide analysis or valuable information about how our applications are being used so that we can improve the service
For advertising and marketing purposes
We may disclose your information for the following purposes.
To comply with our obligations under the law and to protect our rights or property
Our third party partners and service providers have access to your information, and we do not control and are not responsible for the actions of these third parties. Please visit these third party privacy policies yourself
Links to the privacy policies of third-party service providers used by the app
google play services：https://policies.google.com/privacy
AdMob：https://support.google.com/admob
Google Analytics for Firebase：https://firebase.google.com/policies/analytics
Firebase Crashlytics：https://firebase.google.com/support/privacy/
Facebook：https://www.facebook.com/about/privacy/update/printable
Children's Privacy
Our services are not directed to persons under the age of 18. We do not knowingly collect personally identifiable information from people under the age of 18. If you are a parent or guardian and you are aware that your child has provided personal data to us, please contact us. If we become aware that we have collected personal data from a child without verifying parental consent, we will take steps to remove that information from our servers.
Update
We may update our privacy policy from time to time.
Contact us
If you have any questions about this Privacy Policy, please contact us  : lijie230221@outlook.com
viab123456@outlook.com
"""
        case .terms:
            return """
Use of the application
Do not use this application for illegal purposes
Do not use the application for unauthorized commercial purposes
We may discontinue the application without prior notice to you
Update
We may update our Terms of Use from time to time.
Contact us
If you have any questions about these Terms of Use, please contact us : lijie230221@outlook.com
"""
        }
    }
}
