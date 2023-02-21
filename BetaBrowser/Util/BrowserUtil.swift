//
//  BrowserUtil.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import Foundation
import WebKit

class BrowserUtil: NSObject {
    
    static let shared = BrowserUtil()
    
    var items: [BrowserItem] = [.navgationItem]
    
    var item: BrowserItem {
        items.filter {
            $0.isSelect == true
        }.first ?? .navgationItem
    }
    
    var webView: WKWebView {
        return item.webView
    }
    
    func removeItem(_ item: BrowserItem) {
        if item.isSelect {
            if let i = items.firstIndex(of: item) {
                items.remove(at: i )
            }
            items.first?.isSelect = true
        } else {
            if let i = items.firstIndex(of: item) {
                items.remove(at: i )
            }
        }
    }
    
    func clean(from vc: UIViewController) {
        items.filter {
            !$0.isNavigation
        }.compactMap {
            $0.webView
        }.forEach {
            $0.removeFromSuperview()
            if $0.observationInfo != nil {
//                $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress))
//                $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.url))
            }
        }
        items = [.navgationItem]
    }
    
    func add(_ item: BrowserItem = .navgationItem) {
        items.forEach {
            $0.isSelect = false
        }
        items.insert(item, at: 0)
    }
    
    func select(_ item: BrowserItem) {
        if !items.contains(item) {
            return
        }
        items.forEach {
            $0.isSelect = false
        }
        item.isSelect = true
    }
    
    func goBack() {
        item.webView.goBack()
    }
    
    func goForword() {
        item.webView.goForward()
    }
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        item.loadUrl(url, from: vc)
    }
    
    func stopLoad() {
        item.stopLoad()
    }
    
}

class BrowserItem: NSObject {
    
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    
    var webView: WKWebView
    
    var isNavigation: Bool {
        webView.url == nil
    }
    var isSelect: Bool
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        if url.isUrl, let Url = URL(string: url) {
            // 移出 view
            BrowserUtil.shared.items.filter({
                !$0.isNavigation
            }).compactMap({
                $0.webView
            }).forEach {
                $0.removeFromSuperview()
                if $0.observationInfo != nil {
                    $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress))
                    $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.url))
                }
            }
            // 添加 view
            vc.view.addSubview(webView)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.url), context: nil)
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.loadUrl(reqString, from: vc)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    static var navgationItem: BrowserItem {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.clipsToBounds = true
        return BrowserItem(webView: webView, isSelect: true)
    }
}
