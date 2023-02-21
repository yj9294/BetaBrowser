//
//  FirebaseUtil.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/16.
//

import Foundation
import Firebase

class FirebaseUtil: NSObject {
    static func log(event: Event, params: [String: Any]? = nil) {
        
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        if event == .homeShow, BrowserUtil.shared.item.isNavigation {
            log(event: .navigaShow)
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[Event] \(event.rawValue) \(params ?? [:])")
    }
    
    static func log(property: Property, value: String? = nil) {
        
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[Property] \(property.rawValue) \(value ?? "")")
    }
}

enum Property: String {
    /// 設備
    case local = "w"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum Event: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    case open = "e_sb"
    case openCold = "r_sb"
    case openHot = "h_sb"
    case homeShow = "u_sb"
    case navigaShow = "i_sb"
    case navigaClick = "o_sb"
    case navigaSearch = "p_sb"
    case cleanClick = "z_sb"
    case cleanSuccess = "x_sb"
    case cleanAlert = "c_sb"
    case tabShow = "b_sb"
    case tabNew = "v_sb"
    case shareClick = "n_sb"
    case copyClick = "m_sb"
    case webStart = "k_sb"
    case webSuccess = "ll_sb"
}
