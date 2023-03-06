//
//  AppUtil.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/14.
//

import Foundation
import UIKit

class AppUtil {
    static let shared = AppUtil()
    var sceneDelegate: SceneDelegate? = nil
    var root: ViewController? = nil
    var enterbackground:Bool = false
    var darkModel: Bool = UITraitCollection.current.userInterfaceStyle != .dark {
        didSet {
            NotificationCenter.default.post(name: .darkModelDidUpdate, object: nil)
        }
    }
    var isTranslate: Bool = true {
        didSet {
            NotificationCenter.default.post(name: .languageUpdate, object: nil)
        }
    }
}


extension String {
    func localized() -> String{
        if AppUtil.shared.isTranslate {
            return NSLocalizedString(self, comment: "")
        } else {
            return  localizedEnglish()
        }
    }
    
    private func localizedEnglish() -> String {
        return NSLocalizedString(self, tableName: "EnglishLocalizable", comment: "")
    }
}

