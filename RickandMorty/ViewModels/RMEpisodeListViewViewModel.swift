//
//  RMEpisodeListViewViewModel.swift
//  RickandMorty
//
//  Created by ezz on 13/02/2023.
//

import Foundation
import UIKit
protocol RMEpisodeListViewViewModelDelegate : AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
    func didSelectRMEpisode(_ episode : RMEpisode)
}
final class RMEpisodeListViewViewModel : NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes = false
    
    private let borderColors : [UIColor] = [
        .systemBlue   ,
        .systemRed    ,
        .systemYellow ,
        .systemOrange ,
        .systemPink   ,
        .systemPurple ,
        .systemIndigo
    ]
    
    private var episodes : [RMEpisode] = [] {
        didSet{
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url) , borderColor: borderColors.randomElement() ?? .systemBlue)
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels : [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo : RMGetAllEpisodeResponse.Info? = nil
    
    ///Fetch inital Set of Characters (20)
    func FetchEpisodes(){
        RMService.shared.execute(.listEpisodesRequests,
                                 expecting: RMGetAllEpisodeResponse.self) { [weak self]result in
            switch result {
            case .success(let responseModels):
                let results = responseModels.results
                let info = responseModels.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginate if addtional characters are needed
    public func fetchAdditionalEpisodes(url : URL){
        guard !isLoadingMoreEpisodes else { // if false will continue  !false >= true
            return
        }
        isLoadingMoreEpisodes = true
        print("Fetching More Caracters...")
        //Fetch Caharacters
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            print("Faild to create Request...")
            return
        }
        RMService.shared.execute(request,expecting: RMGetAllEpisodeResponse.self) { [weak self]result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModels):
                let moreResults = responseModels.results
                let info = responseModels.info
                
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd : [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                print(indexPathsToAdd)
                strongSelf.episodes.append(contentsOf: moreResults)
                strongSelf.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with:indexPathsToAdd)
                }
                strongSelf.isLoadingMoreEpisodes = false
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreEpisodes = false
            }
        }
        
    }
    
    
    public var shouldShowLoadMoreIndicator : Bool {
        return apiInfo?.next != nil
    }
}
extension RMEpisodeListViewViewModel : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-20)
        return CGSize(width: width,
                      height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectRMEpisode(episode)
        
    }
}

//MARK: - ScrollView
extension RMEpisodeListViewViewModel : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator ,
              !isLoadingMoreEpisodes ,
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
                self?.fetchAdditionalEpisodes(url: url )
            }
            t.invalidate()
        }
    }
}
