//
//  RMSearchInputViewViewModel.swift
//  RickandMorty
//
//  Created by ezz on 23/02/2023.
//

import Foundation
final class RMSearchInputViewViewModel {
    
    private let type : RMSearchViewController.Config.`Type`
    
    enum DynamicOption : String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
    }
    
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    //MARK: - Public
    
    public var hasDynmicTypes : Bool {
        switch type.self {
        case .character:
            return true
        case .location:
            return true
        case .episode:
            return false
        }
    }
    
    public var options : [DynamicOption] {
        switch self.type {
        case .character:
            return [.status , .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    public var searchPlaceholderText : String {
        switch self.type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Name"
        }
    }
    
}
