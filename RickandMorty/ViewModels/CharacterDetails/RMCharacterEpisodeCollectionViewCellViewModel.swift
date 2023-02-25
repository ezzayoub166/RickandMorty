//
//  RMCharacterEpisodeViewModel.swift
//  RickandMorty
//
//  Created by ezz on 08/02/2023.
//

import UIKit

protocol RMEpisodeDataRender {
    var name : String {get}
    var air_date : String {get}
    var episode : String {get}
}


final class RMCharacterEpisodeCollectionViewCellViewModel : Hashable , Equatable {

    
    public let episodeDataUrl : URL?
    private var isFetching = false
    private var dataBlock : ((RMEpisodeDataRender) -> Void)?
    public var borderColor : UIColor
    
    private var episodes : RMEpisode?{
        didSet{
            guard let model = episodes else {
                return
            }
            dataBlock?(model)
          
        }
    }
    
    init(episodeDataUrl : URL? , borderColor : UIColor = .systemBlue){
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    //MARK: - Public
    public func registerForData(_ block : @escaping (RMEpisodeDataRender) -> Void){
        self.dataBlock = block
    }
    
    
    
    func fetchEpisoed(){
        
        guard !isFetching else {
            if let model = episodes {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl ,
              let rmRequest = RMRequest(url: url) else {
            return
        }
        isFetching = true
        RMService.shared.execute(rmRequest,
                                 expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episodes = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
}
