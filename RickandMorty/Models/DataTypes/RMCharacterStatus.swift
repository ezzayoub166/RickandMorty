//
//  RMCharacterStatus.swift
//  RickandMorty
//
//  Created by ezz on 03/02/2023.
//

import Foundation
enum RMCharacterStatus : String , Codable { 
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text : String {
        switch self {
        case .alive , .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
