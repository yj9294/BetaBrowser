//
//  HomeVC+Action.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import Foundation
import MobileCoreServices
import WebKit

extension HomeVC {
    
    @objc func searchAction() {
        view.endEditing(true)
        guard let text = textField.text else {
            alert("Please enter your search content.")
            return
        }
        
        if text.count == 0 {
            alert("Please enter your search content.")
            return
        }
        
        BrowserUtil.shared.loadUrl(text, from: self)
        FirebaseUtil.log(event: .navigaSearch, params: ["lig": text])
    }
    
    @objc func closeAction() {
        isCancelClicked = true
        BrowserUtil.shared.stopLoad()
    }
    
    @objc func gobackAction() {
        BrowserUtil.shared.goBack()
    }
    
    @objc func goforwordAction() {
        BrowserUtil.shared.goForword()
    }
    
    @objc func cleanAction() {
        FirebaseUtil.log(event: .cleanClick)
        alert {
            let vc = CleanVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            vc.handle = {
                FirebaseUtil.log(event: .cleanSuccess)
                FirebaseUtil.log(event: .cleanAlert)
                self.alert("Clean successfully.")
            }
        }
    }
    
    @objc func tabAction() {
        let vc = TabVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func settingAction() {
        let view = SettingView()
        if let bounds = self.view.window?.bounds {
            view.frame = bounds
        }
        self.view.window?.addSubview(view)
        view.didSelect = { item in
            switch item {
            case .new:
                BrowserUtil.shared.webView.removeFromSuperview()
                BrowserUtil.shared.add()
                self.observerViewStatus()
                FirebaseUtil.log(event: .tabNew, params: ["lig": "setting"])
            case .share:
                var url = "https://itunes.apple.com/cn/app/id"
                if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
                    url = text
                }
                let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(vc, animated: true)
                FirebaseUtil.log(event: .shareClick)
            case .copy:
                if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
                    UIPasteboard.general.setValue(text, forPasteboardType: kUTTypePlainText as String)
                    self.alert("Copy successed.")
                } else {
                    UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
                    self.alert("Copy successed.")
                }
                FirebaseUtil.log(event: .copyClick)
            case .terms:
                let vc = HTMLVC(.terms)
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                self.present(navi, animated: true)
            case .privacy:
                let vc = HTMLVC(.privacy)
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                self.present(navi, animated: true)
            case .contact:
                if let url = URL(string: "https://itunes.apple.com/cn/app/id") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func clickItemAction(_ item: HomeItem) {
        FirebaseUtil.log(event: .navigaClick, params: ["lig": item.url])
        BrowserUtil.shared.loadUrl(item.url, from: self)
    }
    
    func observerViewStatus() {
        closeButton.isHidden = !BrowserUtil.shared.webView.isLoading
        searchButton.isHidden = !closeButton.isHidden
        progressView.isHidden = closeButton.isHidden
        tabButton.setTitle("\(BrowserUtil.shared.items.count)", for: .normal)
        tabButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        tabButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        if BrowserUtil.shared.items.count >= 10 {
            tabButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -21.5, bottom: 0, right: 0)
            tabButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21.5, bottom: 0, right: 0)
        }
        textField.text = BrowserUtil.shared.webView.url?.absoluteString
        nextButton.isEnabled = BrowserUtil.shared.webView.canGoForward
        lastButton.isEnabled = BrowserUtil.shared.webView.canGoBack
        BrowserUtil.shared.webView.navigationDelegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let webView = BrowserUtil.shared.webView
        // url重定向
        if keyPath == #keyPath(WKWebView.url) {
            textField.text = webView.url?.absoluteString
        }
        
        if keyPath == #keyPath(WKWebView.canGoBack) {
            lastButton.isEnabled = webView.canGoBack
        }
        
        if keyPath == #keyPath(WKWebView.canGoForward) {
            nextButton.isEnabled = webView.canGoForward
        }
        
        // 进度
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let progress: Float = Float(webView.estimatedProgress)
            debugPrint(progress)
            DispatchQueue.main.async {
                self.progressView.progress = progress
            }
            
            if progress == 0.1 {
                startDate = Date()
                searchButton.isHidden = true
                closeButton.isHidden = false
                FirebaseUtil.log(event: .webStart)
            }
            
            // 加载完成
            if progress == 1.0 {
                progressView.isHidden = true
                progressView.progress = 0.0
                searchButton.isHidden = false
                closeButton.isHidden = true
                let time = Date().timeIntervalSince1970 - startDate!.timeIntervalSince1970
                FirebaseUtil.log(event: .webSuccess, params: ["lig": "\(ceil(time))"])

                
                if webView.url == nil {
                    if closeButton.isHidden == false, !isCancelClicked {
                        self.alert("Load Failed.")
                    } else {
                        self.alert("Canceled.")
                    }
                    webView.removeFromSuperview()
                }
                
                searchButton.isHidden = false
                closeButton.isHidden = true
            } else {
                progressView.isHidden = false
            }
        }
    }
}

extension HomeVC: WKUIDelegate, WKNavigationDelegate {
    /// 跳转链接前是否允许请求url
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    /// 响应后是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward

        webView.load(navigationAction.request)
        
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return nil
    }
}
