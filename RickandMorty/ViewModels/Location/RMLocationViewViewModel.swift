//
//  RMLocationViewViewModel.swift
//  RickandMorty
//
//  Created by ezz on 21/02/2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate : AnyObject {
    func didFetchInitLocations()
}


final class RMLocationViewViewModel {
    
    weak var deleagte : RMLocationViewViewModelDelegate?
    
    private var locations : [RMlocation] = []{
        didSet{
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location:location)
                if !cellViewModels.contains(cellViewModel){
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var apiInfo : RMGetAllLoctionsResponse.Info?
    
    init(){
        
    }
    
    public private(set) var cellViewModels : [RMLocationTableViewCellViewModel] = []

    public func location(at index : Int) -> RMlocation? {
        guard index < locations.count , index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
    public func  fetchLocations(){
        RMService.shared.execute(
            .listLocationRequests,
            expecting: RMGetAllLoctionsResponse.self) {[weak self] result in
                switch result {
            case .success(let model):
                    self?.apiInfo = model.info
                    self?.locations = model.results
                    DispatchQueue.main.async {
                        self?.deleagte?.didFetchInitLocations()
                    }
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreResults : Bool {
        return false
    }
    
}
