//
//  RMLocationDetailsView.swift
//  RickandMorty
//
//  Created by ezz on 23/02/2023.
//

import UIKit

protocol RMLocationDetailsViewViewModelDelegate : AnyObject {
    func didFetchDetailsLocation()
}

final class RMLocationDetailsViewViewModel {
    
    private let location : RMlocation?
    
    private var dataTuple: (location: RMlocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            deleagte?.didFetchDetailsLocation()
        }
    }
    
    enum SectionType {
        case information(viewModels : [RMEpisodeInfoCollectionViewCellViewModel])
        
        case charecte(viewModels : [RMCharacterCollectionViewCellViewModel])
    }
    
    public private (set) var cellViewModels : [SectionType] = []
    
    public weak var deleagte : RMLocationDetailsViewViewModelDelegate?

    
    init(location : RMlocation?){
        self.location = location
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //MARK: Private
    private func createCellViewModels(){
        guard let dataTuple else {
            return
        }
        let location = dataTuple.location
        let resdintes = dataTuple.characters
        var createdString = ""
        if let data = RMCharacterInfoCollectionViewCellViewModel.dataFormatter.date(from: location.created){
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: data)
        }
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString)
            ])
            ,
            .charecte(viewModels: resdintes.compactMap({return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageURL: URL(string: $0.image))}))
        
        ]
    }
    //MARK: - Public
    
    public func fetchLocationDeatils(){
        
        guard let urlString = location?.url, let url = URL(string: urlString) , let request = RMRequest(url:url ) else {
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMlocation.self) { [weak self]result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    
    private func fetchRelatedCharacters(location: RMlocation) {
        let requests: [RMRequest] = location.residents.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })

        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
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

        group.notify(queue: .main) {
            self.dataTuple = (
                location: location,
                characters: characters
            )
        }
    }
}
