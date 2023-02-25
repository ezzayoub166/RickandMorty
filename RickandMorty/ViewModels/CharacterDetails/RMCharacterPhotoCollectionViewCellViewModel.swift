//
//  RMCharacterPhotoViewModel.swift
//  RickandMorty
//
//  Created by ezz on 08/02/2023.
//

import Foundation
final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl : URL?
    
    
    init(imageUrl : URL?){
        self.imageUrl = imageUrl
    }
    
    public func fetchImageData(completion : @escaping (Result<Data , Error>) -> Void){
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
    
}
