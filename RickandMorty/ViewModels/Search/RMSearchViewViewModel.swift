//
//  RMSearchViewViewModel.swift
//  RickandMorty
//
//  Created by ezz on 23/02/2023.
//


//Responsipilites
// - show search Results
// - show No search Results
// - kick off API request
import Foundation
final class RMSearchViewViewModel {
    let config : RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
