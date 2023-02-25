//
//  RMLocationTableViewCellViewModel.swift
//  RickandMorty
//
//  Created by ezz on 21/02/2023.
//

import Foundation
import UIKit
struct RMLocationTableViewCellViewModel : Hashable , Equatable {

    
    private let location : RMlocation
    
    init(location: RMlocation) {
        self.location = location
    }
    
    public var name : String {
        return location.name
    }
    
    public var dimension : String {
        return location.dimension
    }
    
    public var type : String {
        return location.type
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(type)
        hasher.combine(dimension)
    }
}
