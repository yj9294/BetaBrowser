//
//  OCRVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit
import AVFoundation

class OCRVC: BaseVC {
    
    lazy var cameraView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var targetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OCR"
        start()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .black
        super.viewWillAppear(animated)
        initNavigationBar()
        CameraUtil.share.reTake()
        sourceLabel.text = ProfileUtil.share.ocrSourceLanguage.language
        targetLabel.text = ProfileUtil.share.ocrTargetLanguage.language
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CameraUtil.share.stop()
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
    
    
    func start() {
        CameraUtil.share.requestPermission(completion: { isSuccess in
            if isSuccess {
                CameraUtil.share.preview = AVCaptureVideoPreviewLayer(session: CameraUtil.share.session)
                CameraUtil.share.preview.frame = self.view.bounds
                CameraUtil.share.session.startRunning()
                self.cameraView.layer.addSublayer(CameraUtil.share.preview)
            } else {
//                PermissionAlertView.present()
            }
        })
    }
}

extension OCRVC {
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(cameraView)
        cameraView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let sourceView = UIView()
        sourceView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        sourceView.cornerRadius = 12
        view.addSubview(sourceView)
        sourceView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(24)
            make.right.equalTo(view.snp.centerX).offset(-15)
            make.width.equalTo(128)
            make.height.equalTo(44)
        }
        
        sourceView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-30)
        }
        
        let sourceIcon = UIImageView(image: UIImage(named: "ocr_arrow"))
        sourceView.addSubview(sourceIcon)
        sourceIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        
        let translateIcon = UIImageView(image: UIImage(named: "ocr_translate_translate"))
        translateIcon.isUserInteractionEnabled = true
        translateIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exchangeAction)))
        view.addSubview(translateIcon)
        translateIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(sourceView)
        }
        
        let targetView = UIView()
        targetView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        targetView.cornerRadius = 12
        view.addSubview(targetView)
        targetView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(24)
            make.left.equalTo(view.snp.centerX).offset(15)
            make.width.equalTo(128)
            make.height.equalTo(44)
        }
        
        targetView.addSubview(targetLabel)
        targetLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-30)
        }
        
        let targeIcon = UIImageView(image: UIImage(named: "ocr_arrow"))
        targetView.addSubview(targeIcon)
        targeIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        
        
        let sourButton = UIButton()
        sourceView.addSubview(sourButton)
        sourButton.addTarget(self, action: #selector(sourceAction), for: .touchUpInside)
        sourButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let targetButton = UIButton()
        targetView.addSubview(targetButton)
        targetButton.addTarget(self, action: #selector(targetAction), for: .touchUpInside)
        targetButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let pointButton = UIButton()
        pointButton.setImage(UIImage(named: "ocr_take_photo"), for: .normal)
        pointButton.addTarget(self, action: #selector(camerAction), for: .touchUpInside)
        view.addSubview(pointButton)
        pointButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp_bottomMargin).offset(-50)
        }
        
        
    }
    
}


extension OCRVC {
    
    @objc func exchangeAction() {
        let tp = ProfileUtil.share.ocrSourceLanguage
        ProfileUtil.share.ocrSourceLanguage = ProfileUtil.share.ocrTargetLanguage
        ProfileUtil.share.ocrTargetLanguage = tp
        
        sourceLabel.text =  ProfileUtil.share.ocrSourceLanguage.language
        targetLabel.text = ProfileUtil.share.ocrTargetLanguage.language
    }
    
    @objc func sourceAction() {
        
        let datasource:[Language] = ProfileUtil.share.sourceDatasource.flatMap{
            $0
        }
        
        let vc = CountryListVC()
        vc.datasource = datasource
        vc.language = ProfileUtil.share.ocrSourceLanguage
        vc.completion = { lan in
            ProfileUtil.share.ocrSourceLanguage = lan
            self.sourceLabel.text = lan.language
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
        vc.language = ProfileUtil.share.ocrTargetLanguage
        vc.completion = { lan in
            ProfileUtil.share.ocrTargetLanguage = lan
            self.targetLabel.text = lan.language
        }
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func camerAction() {
        let source = ProfileUtil.share.ocrSourceLanguage
        let target = ProfileUtil.share.ocrTargetLanguage

        CameraUtil.share.requestPermission { isSuccess in
            if AppUtil.shared.enterbackground {
                return
            }
            
            if !isSuccess {
//                PermissionAlertView.present()
                return
            }
            
            LoadingView.present(from: self)
            // 拍照
            CameraUtil.share.takePic { [weak self] isSuccess in
                if AppUtil.shared.enterbackground {
                    return
                }
                guard let self = self else { return }
                if !isSuccess {
                    LoadingView.dismiss(with: self)
                    self.alert("Failed to translate.")
                    CameraUtil.share.reTake()
                    return
                }
                let sourceLan = ProfileUtil.share.ocrSourceLanguage.code
                let image = CameraUtil.share.image
                let direction = CameraUtil.share.orientation
                
                // 拍照错误
                guard let image = image else {
                    LoadingView.dismiss(with: self)
                    return
                }
                
                // 拍照成功进行识别
                TranslateUtil.share.ocrTranslate(source: sourceLan, image: image, direction: direction) { isSuccess, result in
                    if AppUtil.shared.enterbackground {
                        return
                    }
                    if !isSuccess {
                        LoadingView.dismiss(with: self)
                        self.alert(result)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            CameraUtil.share.reTake()
                        }
                        return
                    }
                    TranslateUtil.share.isOCR = true
                    
                    // 识别成功进行翻译
                    TranslateUtil.share.translate(text: result, source: source, target: target) { isSuccess, r in
                        LoadingView.dismiss(with: self)
                        if !isSuccess {
                            self.alert(result)
                            CameraUtil.share.reTake()
                            return
                        }
                        self.navigationItem.backButtonTitle = ""
                        let vc = OCRResultVC()
                        vc.image = image
                        vc.result = r
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
}
