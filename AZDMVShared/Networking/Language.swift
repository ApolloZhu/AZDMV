//
//  Language.swift
//  AZDMV
//
//  Created by Apollo Zhu on 9/14/18.
//  Copyright © 2016-2020 DMV A-Z. MIT License.
//

/// All languages that Microsoft Translator supports, as of now.
enum Language: String, CaseIterable {
    case English = "en"
    case Spanish = "es"
    case Afrikaans = "af"
    case Arabic = "ar"
    case Bulgarian = "bg"
    case Bangla = "bn"
    case Bosnian = "bs"
    case Catalan = "ca"
    case Czech = "cs"
    case Welsh = "cy"
    case Danish = "da"
    case German = "de"
    case Greek = "el"
    case Estonian = "et"
    case Persian = "fa"
    case Finnish = "fi"
    case Filipino = "fil"
    case Fijian = "fj"
    case French = "fr"
    case Hebrew = "he"
    case Hindi = "hi"
    case Croatian = "hr"
    case HaitianCreole = "ht"
    case Indonesian = "id"
    case Icelandic = "is"
    case Italian = "it"
    case Japanese = "ja"
    case Korean = "ko"
    case Hungarian = "hu"
    case Lithuanian = "lt"
    case Latvian = "lv"
    case Malagasy = "mg"
    case Malay = "ms"
    case Maltese = "mt"
    case HmongDaw = "mww"
    case Norwegian = "nb"
    case Dutch = "nl"
    case QuerétaroOtomi = "otq"
    case Polish = "pl"
    case Portuguese = "pt"
    case Romanian = "ro"
    case Russian = "ru"
    case Slovak = "sk"
    case Slovenian = "sl"
    case Samoan = "sm"
    case SerbianCyrillic = "sr-Cyrl"
    case SerbianLatin = "sr-Latn"
    case Swedish = "sv"
    case Kiswahili = "sw"
    case Tamil = "ta"
    case Telugu = "te"
    case Thai = "th"
    case Klingon = "tlh"
    case Tongan = "to"
    case Turkish = "tr"
    case Tahitian = "ty"
    case Ukrainian = "uk"
    case Urdu = "ur"
    case Vietnamese = "vi"
    case YucatecMaya = "yua"
    case CantoneseTraditional = "yue"
    case ChineseSimplified = "zh-Hans"
    case ChineseTraditional = "zh-Hant"
}

extension Language {
    /// Suitable for user interface
    var nativeName: String {
        switch self {
        case .English: return "English"
        case .Spanish: return "Español"
        case .Afrikaans: return "Afrikaans"
        case .Arabic: return "العربية"
        case .Bulgarian: return "Български"
        case .Bangla: return "বাংলা"
        case .Bosnian: return "bosanski (latinica)"
        case .Catalan : return "Català"
        case .Czech: return "Čeština"
        case .Welsh: return "Welsh"
        case .Danish: return "Dansk"
        case .German: return "Deutsch"
        case .Greek: return "Ελληνικά"
        case .Estonian: return "Eesti"
        case .Persian: return "Persian"
        case .Finnish: return "Suomi"
        case .Filipino: return "Filipino"
        case .Fijian: return "Fijian"
        case .French: return "Français"
        case .Hebrew: return "עברית"
        case .Hindi: return "हिंदी"
        case .Croatian: return "Hrvatski"
        case .HaitianCreole: return "Haitian Creole"
        case . Hungarian: return "Magyar"
        case .Indonesian: return "Indonesia"
        case .Icelandic: return "Íslenska"
        case .Italian: return "Italiano"
        case .Japanese: return "日本語"
        case .Korean:  return "한국어"
        case .Lithuanian: return "Lietuvių"
        case .Latvian: return "Latviešu"
        case .Malagasy: return "Malagasy"
        case .Malay: return "Melayu"
        case .Maltese: return "Il-Malti"
        case .HmongDaw: return "Hmong Daw"
        case .Norwegian: return "Norsk"
        case .Dutch: return "Nederlands"
        case .QuerétaroOtomi: return "Querétaro Otomi"
        case .Polish: return "Polski"
        case .Portuguese: return "Português"
        case .Romanian: return "Română"
        case .Russian: return "Русский"
        case .Slovak: return "Slovenčina"
        case .Slovenian: return "Slovenščina"
        case .Samoan: return "Samoan"
        case .SerbianCyrillic: return "srpski (ćirilica)"
        case .SerbianLatin: return "srpski (latinica)"
        case .Swedish: return "Svenska"
        case .Kiswahili: return "Kiswahili"
        case .Tamil: return "தமிழ்"
        case .Telugu: return "తెలుగు"
        case .Thai: return "ไทย"
        case .Klingon: return "Klingon"
        case .Tongan: return "lea fakatonga"
        case .Turkish: return "Türkçe"
        case .Tahitian: return "Tahitian"
        case .Ukrainian: return "Українська"
        case .Urdu: return "اردو"
        case .Vietnamese: return "Tiếng Việt"
        case .YucatecMaya: return "Yucatec Maya"
        case .CantoneseTraditional: return "粵語 (繁體中文)"
        case .ChineseSimplified: return "简体中文"
        case .ChineseTraditional: return "繁體中文"
        }
    }
}

// MARK: - Preferred UI Language

import Foundation

extension Language {
    /// Preferred Interface Language
    static var preferred: Language {
        get {
            return .English
            // if let preferred = cachedPreferred {
            //     return preferred
            // }
            // if let stored = UserDefaults.standard.string(forKey: preferredKey),
            //     let preferred = Language(rawValue: stored) {
            //     cachedPreferred = preferred
            //     return preferred
            // }
            // let preferred = calculatePreferred()
            // cachedPreferred = preferred
            // return preferred
        }
        set {
            cachedPreferred = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: preferredKey)
        }
    }
    
    // MARK: - Helpers
    
    /// For UserDefaults preference keeping.
    private static let preferredKey = "Language.preferred"
    
    /// Speed is more important than space.
    private static var cachedPreferred: Language? = nil
    
    /// A more robust constructor.
    public init?(languageCode: String) {
        if let language = Language(rawValue: languageCode) {
            self = language
        } else if let prefix = languageCode.split(separator: "-").first,
                  let language = Language(rawValue: "\(prefix)") {
            self = language
        } else {
            return nil
        }
    }
    
    /// Choose the most appropriate language based on many factors.
    private static func calculatePreferred() -> Language {
        return .English
        // var languages = Locale.preferredLanguages
        // if let languageCode = Locale.current.languageCode {
        //     languages.insert(languageCode, at: 1)
        // }
        // for preferred in languages.lazy {
        //     if let language = Language(languageCode: preferred) {
        //         return language
        //     }
        // }
        // return .English
    }
}
