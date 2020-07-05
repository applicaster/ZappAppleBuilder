//
//  ZPBroadcasterPickerTypes.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 11/11/2019.
//

@objc public enum ZPBroadcasterPickerType: Int {
    case undefined = 0
    case localization
    case germanCountryIP
    case countryIP
    
    var relatedClassString: String {
        var str: String
        switch self {
        case .localization:
            str = "ZappBroadcasterPickerPlugins.APBroadcasterPickerByLocalization"
            break
        case .germanCountryIP:
            str = "ZappBroadcasterPickerPlugins.APBroadcasterPickerByGermanCountryIP"
            break
        case .countryIP:
            str = "ZappBroadcasterPickerPlugins.APBroadcasterPickerByCountryIP"
            break
        default:
            str = ""
            break
        }
        return str
    }
    
    func description() -> String {
        switch self {
        case .localization:
            return "Localization"
        case .germanCountryIP:
            return "GermanCountryIP"
        case .countryIP:
            return "CountryIP"
        default:
            return String(self.rawValue)
        }
    }
}
