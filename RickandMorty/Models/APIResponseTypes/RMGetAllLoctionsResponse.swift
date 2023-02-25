//
//  RMGetAllLoctionsResponse.swift
//  RickandMorty
//
//  Created by ezz on 21/02/2023.
//

import Foundation
import Foundation
struct RMGetAllLoctionsResponse : Codable {
    struct Info : Codable {
        let count : Int
        let pages : Int
        let next : String?
        let prev : String?
    }
    let info : Info
    let results : [RMlocation]
}
