//
//  ProfileUtil.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit

import MLKitTranslate

class ProfileUtil: NSObject {
    static let share = ProfileUtil()
    
    var textGuide: Bool {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .textGuide)
        }
        get{
            UserDefaults.standard.getObject(Bool.self, forKey: .textGuide) ?? false
        }
    }
    
    var ocrGuide: Bool {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .ocrGuide)
        }
        get{
            UserDefaults.standard.getObject(Bool.self, forKey: .ocrGuide) ?? false
        }
    }
    
    var textSourceLanguage: Language {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .textSourceKey)
        }
        get{
            UserDefaults.standard.getObject(Language.self, forKey: .textSourceKey) ?? .Auto
        }
    }
    var textTargetLanguage: Language {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .textTargetKey)
        }
        get{
            UserDefaults.standard.getObject(Language.self, forKey: .textTargetKey) ?? .English
        }
    }
    var ocrSourceLanguage: Language {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .ocrSourceKey)
        }
        get{
            UserDefaults.standard.getObject(Language.self, forKey: .ocrSourceKey) ?? .Auto
        }
    }
    var ocrTargetLanguage: Language {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .ocrTargetKey)
        }
        get{
            UserDefaults.standard.getObject(Language.self, forKey: .ocrTargetKey) ?? .English
        }
    }
    
    var targetDatasource: [[Language]] {
        return [datasource]
    }
    
    var sourceDatasource: [[Language]] {
        return [[.Auto], datasource]
    }
    
    var translateText: String {
        set {
            UserDefaults.standard.setObject(newValue, forKey: .translateText)
        }
        get {
            UserDefaults.standard.getObject(String.self, forKey: .translateText) ?? ""
        }
    }
    
    var datasource: [Language] {
        if let source = UserDefaults.standard.getObject([Language].self, forKey: .targetSource) {
            return source
        } else {
            let array: [Language] = TranslateLanguage.allLanguages().compactMap {
                let country = Locale.current.localizedString(forRegionCode: $0.rawValue) ?? ""
                let code = $0.rawValue
                let language = Locale.current.localizedString(forLanguageCode: $0.rawValue) ?? ""
                return Language(code: code, country: country, language: language)
            }.sorted { l1, l2 in
                l1.language < l2.language
            }
            UserDefaults.standard.setObject(array, forKey: .targetSource)
            return array
        }
    }
}

extension String {
    static let textGuide = "textGuide"
    static let ocrGuide = "ocrGuide"
    static let textSourceKey = "textSourceKey"
    static let textTargetKey = "textTargetKey"
    static let ocrSourceKey = "ocrSourceKey"
    static let ocrTargetKey = "ocrTargetKey"
    static let targetSource = "targetSource"
    static let translateText = "translateText"
    static let adConfig = "adConfig"
    static let adLimited = "adLimited"
    static let adUnAvaliableDate = "adUnAvaliableDate"
}

struct Language: Equatable, Codable {
    var code: String
    var country: String = ""
    var language: String = ""
    
    func prefixA() -> String {
        if language.count > 0 {
            return String(language.uppercased().prefix(1))
        }
        return ""
    }
    
    static var Auto: Language {
        return Language(code: "und", country: "", language: "Auto")
    }
    static var English: Language {
        return Language(code: "en", country: "United States", language: "English")
    }
    
    static func ==(lhs: Language, rhs: Language) -> Bool {
        return lhs.code == rhs.code
    }
}

extension UserDefaults {
    func setObject<T: Encodable> (_ object: T?, forKey key: String) {
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
    
    func getObject<T: Decodable> (_ type: T.Type, forKey key: String) -> T? {
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

