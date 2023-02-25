//
//  RMEndpoint.swift
//  RickandMorty
//
//  Created by ezz on 03/02/2023.
//

import Foundation
// CaseIterable for can loop over all three of these endpoints
/// Representes unique API endpoint
@frozen enum RMEndpoint : String , CaseIterable , Hashable {
    /// Endpoint to get chearacter Info
    case character
    /// Endpoint to get location Info
    case location
    /// Endpoint to get episode Info
    case episode
}
