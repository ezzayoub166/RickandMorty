//
//  RMLocations.swift
//  RickandMorty
//
//  Created by ezz on 02/02/2023.
//

import Foundation

struct RMlocation : Codable{
    let id: Int
    let name: String
    let type:  String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
