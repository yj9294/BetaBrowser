//
//  HomeVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/14.
//

import UIKit
import AppTrackingTransparency

class HomeVC: BaseVC {
    
    var startDate: Date?
    var isCancelClicked: Bool = false
    var willAppear = false
    var collection: UICollectionView? = nil
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Seaech or enter address"
        view.delegate = self
        view.textColor = UIColor(named: "#333333")
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "home_search"), for: .normal)
        view.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "home_close"), for: .normal)
        view.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = UIColor(named: "#4C8877")
        view.tintColor = UIColor(named: "#6EEBC3")
        view.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var adView: GADNativeView = {
        let view = GADNativeView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var textTranslateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(textTranslateAction), for: .touchUpInside)
        return button
    }()
    
    lazy var ocrTranslateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(ocrTranslateAction), for: .touchUpInside)
        return button
    }()
    
    lazy var lastButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_last"), for: .normal)
        button.addTarget(self, action: #selector(gobackAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_next"), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(goforwordAction), for: .touchUpInside)
        return button
    }()
    
    lazy var tabButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_tab"), for: .normal)
        button.addTarget(self, action: #selector(tabAction), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "#333333"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkUtil.shared.startMonitoring()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
        }
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            if let ad = noti.object as? NativeADModel, self?.willAppear == true {
                if Date().timeIntervalSince1970 - (GADUtil.share.homeNativeAdImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADUtil.share.homeNativeAdImpressionDate = Date()
                } else {
                    NSLog("[ad] 10s home 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BrowserUtil.shared.webView.frame = contentView.frame
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppUtil.shared.root?.selectedIndex == 1, willAppear == false {
            willAppear = true
            GADUtil.share.load(.interstitial)
            GADUtil.share.load(.native)
        }
        FirebaseUtil.log(event: .homeShow)
        if BrowserUtil.shared.webView.url != nil {
            view.addSubview(BrowserUtil.shared.webView)
        }
        observerViewStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        BrowserUtil.shared.webView.removeFromSuperview()
        GADUtil.share.close(.native)
    }
}

extension HomeVC {
    
    override func setupUI() {
        super.setupUI()
        let searchView = UIView()
        searchView.layer.borderColor =  UIColor.black.cgColor
        searchView.layer.borderWidth = 1
        searchView.cornerRadius = 8
        view.addSubview(searchView)
        var width = 375.0;
        if let view = AppUtil.shared.sceneDelegate?.window  {
            width = view.frame.width;
        }
        let iPhoneSE = width == 375.00
        let radio =  304.0 / 108.0
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view.snp.left).offset(28)
            make.right.equalTo(view.snp.right).offset(-28)
        }
        
        searchView.addSubview(textField)
        self.textField.textColor = AppUtil.shared.darkModel ? UIColor(named: "#333333") : .white
        if AppUtil.shared.darkModel {
            self.textField.attributedPlaceholder = NSAttributedString(string: "search_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: AppUtil.shared.darkModel ? UIColor(white: 0, alpha: 0.4): UIColor(white: 1, alpha: 0.4)])
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(searchView).offset(18)
            make.left.equalTo(searchView).offset(16)
            make.bottom.equalTo(searchView).offset(-18)
            make.right.equalTo(searchView).offset(-60)
        }
        
        searchView.addSubview(searchButton)
        searchButton.tintColor = AppUtil.shared.darkModel ? .black : .white
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchView)
            make.right.equalTo(searchView).offset(-16)
        }
        
        searchView.addSubview(closeButton)
        closeButton.tintColor = AppUtil.shared.darkModel ? .black : .white
        closeButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(searchButton)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.equalTo(searchView)
            make.height.equalTo(1)
        }
        
        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(65)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(iPhoneSE ? 0 : 10)
            make.left.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        let w = (width - 32 - 16) / 2.0
        
        let textBackground: UIImageView = UIImageView(image: UIImage(named: "text_translate"))
        textBackground.isUserInteractionEnabled = true
        textBackground.contentMode = .scaleToFill
        contentView.addSubview(textBackground)
        textBackground.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(iPhoneSE ? 10 : 28)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(w)
            make.height.equalTo(w / radio)
        }
    
        
        let textIcon: UILabel = UILabel()
        textIcon.text = "Text Translate";
        textIcon.textColor = UIColor.black
        textIcon.font = UIFont.systemFont(ofSize: iPhoneSE ? 12 : 16)
        textBackground.addSubview(textIcon)
        textIcon.snp.makeConstraints { make in
            make.centerY.equalTo(textBackground)
            make.right.equalTo(textBackground).offset(iPhoneSE ? -15 : -26)
        }
        
        let ocrBackground: UIImageView = UIImageView(image: UIImage(named: "ocr_translate"))
        ocrBackground.isUserInteractionEnabled = true
        ocrBackground.contentMode = .scaleToFill
        contentView.addSubview(ocrBackground)
        ocrBackground.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(iPhoneSE ? 10 : 18)
            make.left.equalTo(textBackground.snp.right).offset(16)
            make.width.equalTo(w)
            make.height.equalTo(w / radio)
        }
        
        let ocrIcon: UILabel = UILabel()
        ocrIcon.text = "Text Translate";
        ocrIcon.textColor = UIColor.black
        ocrIcon.font = UIFont.systemFont(ofSize: iPhoneSE ? 12 : 16)
        ocrBackground.addSubview(ocrIcon)
        ocrIcon.snp.makeConstraints { make in
            make.centerY.equalTo(ocrBackground)
            make.right.equalTo(ocrBackground).offset(iPhoneSE ? -15 : -26)
        }
        
        contentView.addSubview(textTranslateButton)
        textTranslateButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(textBackground)
        }
        
        contentView.addSubview(ocrTranslateButton)
        ocrTranslateButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(ocrBackground)
        }
        
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.backgroundView?.backgroundColor = .clear
        contentView.addSubview(collection)
        collection.register(HomeCell.classForCoder(), forCellWithReuseIdentifier: "HomeCell")
        collection.snp.makeConstraints { make in
            make.top.equalTo(ocrBackground.snp.bottom).offset(36)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.height.equalTo((width / 4.0 - 10) * 2 + 20)
        }
                
        contentView.addSubview(adView)
        adView.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).offset(20)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        
        bottomView.addSubview(lastButton)
        lastButton.tintColor = AppUtil.shared.darkModel ? .white : .black
        lastButton.snp.makeConstraints { make in
            make.left.equalTo(bottomView).offset(16)
            make.top.bottom.equalTo(bottomView)
        }
        
        bottomView.addSubview(nextButton)
        nextButton.tintColor = AppUtil.shared.darkModel ? .white : .black
        nextButton.snp.makeConstraints { make in
            make.left.equalTo(lastButton.snp.right)
            make.top.bottom.equalTo(bottomView)
        }
        
        let cleanButton = UIButton()
        cleanButton.setImage(UIImage(named: "home_clean"), for: .normal)
        cleanButton.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        bottomView.addSubview(cleanButton)
        cleanButton.tintColor = AppUtil.shared.darkModel ? .white : .black
        cleanButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(bottomView)
            make.left.equalTo(nextButton.snp.right)
        }
        
        bottomView.addSubview(tabButton)
        tabButton.tintColor = AppUtil.shared.darkModel ? .white : .black
        tabButton.setTitleColor(tabButton.tintColor, for: .normal)
        tabButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(bottomView)
            make.left.equalTo(cleanButton.snp.right)
        }
        
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "home_setting"), for: .normal)
        settingButton.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        bottomView.addSubview(settingButton)
        settingButton.tintColor = AppUtil.shared.darkModel ? .white : .black
        settingButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(bottomView)
            make.right.equalTo(bottomView).offset(-16)
            make.left.equalTo(tabButton.snp.right)
            make.width.equalTo(lastButton)
            make.width.equalTo(nextButton)
            make.width.equalTo(cleanButton)
            make.width.equalTo(tabButton)
        }
        
        NotificationCenter.default.addObserver(forName: .darkModelDidUpdate, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return }
            self.textField.textColor = AppUtil.shared.darkModel ? UIColor(named: "#333333") : .white
            if AppUtil.shared.darkModel {
                self.textField.attributedPlaceholder = NSAttributedString(string: "search_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: AppUtil.shared.darkModel ? UIColor(white: 0, alpha: 0.4): UIColor(white: 1, alpha: 0.4)])
            }
            
            self.searchButton.tintColor = AppUtil.shared.darkModel ? .black : .white
            self.closeButton.tintColor = AppUtil.shared.darkModel ? .black : .white
            self.lastButton.tintColor = AppUtil.shared.darkModel ? .white : .black
            self.nextButton.tintColor = AppUtil.shared.darkModel ? .white : .black
            cleanButton.tintColor = AppUtil.shared.darkModel ? .white : .black
            self.tabButton.tintColor = AppUtil.shared.darkModel ? .white : .black
            settingButton.tintColor = AppUtil.shared.darkModel ? .white : .black
            self.tabButton.setTitleColor(self.tabButton.tintColor, for: .normal)
            self.collection?.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: .languageUpdate, object: nil, queue: .main) { [weak self]_ in
            guard let self = self else {return }
            self.collection?.reloadData()
        }
    }
    
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath)
        if let cell = cell as? HomeCell {
            cell.item = HomeItem.allCases[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: width / 4.0 - 10, height: width / 4.0 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickItemAction(HomeItem.allCases[indexPath.row])
    }
    
}


class HomeCell: UICollectionViewCell {
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(named: "#333333")
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.height.equalTo(44)
        }
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
    }
    
    var item: HomeItem? = nil {
        didSet {
            if let image = item?.icon {
                icon.image = UIImage(named: image)
            }
            title.text = item?.rawValue.localized()
            title.textColor = AppUtil.shared.darkModel ? .white : .black
        }
    }
    
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }
    
}

enum HomeItem: String, CaseIterable {
    
    case facebook, google, instagram, youtube, amazon, gmail, yahoo, twitter
    
    var url: String {
        return "https://\(self).com"
    }
    
    var icon: String {
        return "home_\(self)"
    }
}
        
extension Notification.Name {
    static let darkModelDidUpdate = Notification.Name(rawValue: "dark.model.updated")
    static let languageUpdate = Notification.Name(rawValue: "language.update")
}
