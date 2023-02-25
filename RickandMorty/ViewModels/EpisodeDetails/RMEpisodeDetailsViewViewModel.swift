//
//  RMEpisodeDetailsViewViewModel.swift
//  RickandMorty
//
//  Created by ezz on 13/02/2023.
//

import UIKit

protocol RMEpisodeDetailsViewViewModelDelegate : AnyObject {
    func didFetchEpisodeDetails()
}

class RMEpisodeDetailsViewViewModel  {

    private let endpointUrl : URL?
    
    
    enum SectionType {
        case information(viewModels : [RMEpisodeInfoCollectionViewCellViewModel])
        case character(viewModels : [RMCharacterCollectionViewCellViewModel])
    }
    
    public private (set) var cellViewModels : [SectionType] = []
    
    public weak var delegate : RMEpisodeDetailsViewViewModelDelegate?
    
    private var dataTuple : (episodes : RMEpisode , characters :[RMCharacter])?{
        didSet{
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    
    
    //MARK: Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        
    }
    
    
    //MARK: Private
    
    
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
        let episodes = dataTuple.episodes
        let character = dataTuple.characters
        var createdString = ""
        if let data = RMCharacterInfoCollectionViewCellViewModel.dataFormatter.date(from: episodes.created){
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: data)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episodes.name),
                .init(title: "Air Date", value: episodes.air_date),
                .init(title: "Episode", value: episodes.episode),
                .init(title: "Created", value: createdString)
            ])
            ,
            .character(viewModels: character.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                              characterStatus: $0.status,
                                                              characterImageURL: URL(string :$0.image))
            }))
        
        
        ]
    }
    
    //MARK: Public
    
    public func character(at index : Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    public func fetchEpisodeData(){
        guard let url = endpointUrl , let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { [weak self]result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
                print("This must get the releatd Characters...\(model.name)")
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
    
    private func fetchRelatedCharacters(episode : RMEpisode){
        let requests : [RMRequest] = episode.characters.compactMap({return URL(string: $0)})
            .compactMap({return RMRequest(url: $0)})
        
        let group = DispatchGroup()
        var characters : [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request,
                                     expecting: RMCharacter.self) { result in
                defer{
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                        break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTuple = (
             episode ,
            characters
            )
        }
    }

}

/*
 characterUrls
 
 [https://rickandmortyapi.com/api/character/1, https://rickandmortyapi.com/api/character/2, https://rickandmortyapi.com/api/character/3, https://rickandmortyapi.com/api/character/4, https://rickandmortyapi.com/api/character/5, https://rickandmortyapi.com/api/character/38, https://rickandmortyapi.com/api/character/58, https://rickandmortyapi.com/api/character/82, https://rickandmortyapi.com/api/character/83, https://rickandmortyapi.com/api/character/92, https://rickandmortyapi.com/api/character/155, https://rickandmortyapi.com/api/character/175, https://rickandmortyapi.com/api/character/179, https://rickandmortyapi.com/api/character/181, https://rickandmortyapi.com/api/character/216, https://rickandmortyapi.com/api/character/234, https://rickandmortyapi.com/api/character/239, https://rickandmortyapi.com/api/character/249, https://rickandmortyapi.com/api/character/251, https://rickandmortyapi.com/api/character/271, https://rickandmortyapi.com/api/character/293, https://rickandmortyapi.com/api/character/338, https://rickandmortyapi.com/api/character/343, https://rickandmortyapi.com/api/character/394]
 
 
 requests
 
 [RickandMorty.RMRequest,
 RickandMorty.RMRequest,
 RickandMorty.RMRequest,
 RickandMorty.RMRequest,
 RickandMorty.RMRequest,
 RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest, RickandMorty.RMRequest]
 
 
 */
