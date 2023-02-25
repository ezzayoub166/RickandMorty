//
//  Extenstions.swift
//  RickandMorty
//
//  Created by ezz on 04/02/2023.
//

import UIKit
extension UIView {
    func addSubviews(_ views : UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
