//
//  CharacterListViewViewModel.swift
//  RickandMorty
//
//  Created by ezz on 04/02/2023.
//

import UIKit
protocol RMCharacterListViewViewModelDelegate : AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPath: [IndexPath])
    func didSelectRMCaracter(_ character : RMCharacter)
}
final class RMCharacterListViewViewModel : NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters : [RMCharacter] = [] { 
        didSet{
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image))
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels : [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo : RMGetAllCharactersResponse.Info? = nil
    
    ///Fetch inital Set of Characters (20)
    func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequests,
                                 expecting: RMGetAllCharactersResponse.self) { [weak self]result in
            switch result {
            case .success(let responseModels):
                let results = responseModels.results
                let info = responseModels.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginate if addtional characters are needed
    public func fetchAdditionalCharacters(url : URL){
        guard !isLoadingMoreCharacters else { // if false will continue  !false >= true
            return
        }
        isLoadingMoreCharacters = true
        print("Fetching More Caracters...")
        //Fetch Caharacters
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Faild to create Request...")
            return
        }
        RMService.shared.execute(request,expecting: RMGetAllCharactersResponse.self) { [weak self]result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModels):
                let moreResults = responseModels.results
                let info = responseModels.info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount 
                let indexPathsToAdd : [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                strongSelf.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with:indexPathsToAdd)
                }
                strongSelf.isLoadingMoreCharacters = false
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreCharacters = false
            }
        }
        
    }
    
    
    public var shouldShowLoadMoreIndicator : Bool {
        return apiInfo?.next != nil
    }
}
extension RMCharacterListViewViewModel : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath
        ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width,
                      height: width*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectRMCaracter(character)
        
    }
}

//MARK: - ScrollView
extension RMCharacterListViewViewModel : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator ,
              !isLoadingMoreCharacters ,
              !cellViewModels.isEmpty,
        let nextUrlString = apiInfo?.next ,
        let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self]t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
    //        print(offset)
    //        print(totalContentHeight)
    //        print(totalScrollViewFixedHeight)
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                self?.fetchAdditionalCharacters(url: url )
            }
            t.invalidate()
        }
    }
}
