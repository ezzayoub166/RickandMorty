//
//  RMSettingsOption.swift
//  RickandMorty
//
//  Created by ezz on 18/02/2023.
//

import UIKit

enum RMSettingsOption : CaseIterable { //CaseIterable for loop for all cases
    case rateApp
    case contactsUs
    case terms
    case privcy
    case apiRefrence
    case viewSeries
    case viewCode
    
    var displayTitle : String {
        switch self {
        case .rateApp    : return "Rate App"
        case .contactsUs : return "Contact Us"
        case .terms      : return "Terms of Privcy"
        case .privcy     : return "Privcy Policy"
        case .apiRefrence: return "API Reference"
        case .viewSeries : return "View Video Series"
        case .viewCode   : return "View App Code"
        }
    }
    
    var iconContainerColor : UIColor {
        switch self {
        case .rateApp:
            return .systemRed
        case .contactsUs:
            return .systemPink
        case .terms:
            return .systemBlue
        case .privcy:
            return .systemTeal
        case .apiRefrence:
            return .systemYellow
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemOrange
        }
    }
    
    var targetUrl : URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactsUs:
            return URL(string :"https://www.iosacademy.io")
        case .terms:
            return URL(string :"https://www.iosacademy.io/terms/")
        case .privcy:
            return URL(string: "https://www.iosacademy.io/privacy/")
        case .apiRefrence:
            return URL(string: "https://rickandmortyapi.com")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y")
        case .viewCode:
            return URL(string: "https://github.com/AfrazCodes/RickAndMortyiOSApp.git")
        }
    }
    
    var iconImage : UIImage? {
        switch self {
        case .rateApp:      return UIImage(systemName: "star.fill")
        case .contactsUs:   return UIImage(systemName: "paperplane")
        case .terms:        return UIImage(systemName: "doc")
        case .privcy:       return UIImage(systemName: "lock")
        case .apiRefrence:  return UIImage(systemName: "list.clipboard")
        case .viewSeries:   return UIImage(systemName: "tv.fill")
        case .viewCode:     return UIImage(systemName: "hammer.fill")
        }
    }
}
