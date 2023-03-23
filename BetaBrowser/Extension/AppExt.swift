//
//  AppExt.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/14.
//

import Foundation
import UIKit

/// 扩展属性关联Key
private struct AssociatedKey {
    /// 当前touch状态Key
    static var cornerRadius = "cornerRadiusKey"
}

extension UIView {
    var cornerRadius: Double {
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            objc_setAssociatedObject(self, &AssociatedKey.cornerRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssociatedKey.cornerRadius) as? Double) ?? 0.0
        }
    }
}

extension UIViewController {
    func alert(_ message: String) {
        let vc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        if AppUtil.shared.root?.selectedIndex == 1 {
            self.present(vc, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            vc.dismiss(animated: true)
        }
    }
    
    func alert(_ confirm: (()->Void)? = nil) {
        let vc = AlertController()
        
        vc.view.backgroundColor = AppUtil.shared.darkModel ? UIColor(white: 1, alpha: 0.5) : UIColor(white: 0, alpha: 0.5)
        vc.modalPresentationStyle = .overCurrentContext
        vc.handle = confirm
        if AppUtil.shared.root?.selectedIndex == 1 {
            AppUtil.shared.root?.present(vc, animated: true)
        }

    }
}

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
        
    }
}

extension UserDefaults {
    func setModel<T: Encodable> (_ object: T?, forKey key: String) {
        let encoder =  JSONEncoder()
        guard let object = object else {
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        self.setValue(encoded, forKey: key)
    }
    
    func model<T: Decodable> (_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Could'n find key")
            return nil
        }
        
        return object
    }
}

