//
//  RMSearchView.swift
//  RickandMorty
//
//  Created by ezz on 23/02/2023.
//

import UIKit

protocol RMSearchViewDelegate : AnyObject {
    func rmSearchView(_ searchView : RMSearchView , didSelectOption option : RMSearchInputViewViewModel.DynamicOption)
}
final class RMSearchView: UIView {
    
    
    weak var delegate : RMSearchViewDelegate?
    
    private let viewModel : RMSearchViewViewModel
    
    //MARK: - subViews
    
    //SearchInputView
    private let SearchInputview = RMSearchInputView()
    
    //No Results View
    private let noResultsView = RMSearchNoResultsView()
    
    //Results collectionView
    
    //MARK: -Init
    
    init(frame: CGRect , viewModel : RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView , SearchInputview)
        applayConstraints()
        SearchInputview.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        SearchInputview.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applayConstraints(){
        NSLayoutConstraint.activate([
            
            //Input View
            SearchInputview.topAnchor.constraint(equalTo: topAnchor),
            SearchInputview.rightAnchor.constraint(equalTo: rightAnchor),
            SearchInputview.leftAnchor.constraint(equalTo: leftAnchor),
            SearchInputview.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 50 : 110),
            
            //No Results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo:centerYAnchor),
        
        ])
    }
    
    public func presentKeyboard(){
        SearchInputview.presentKeyboard()
    }
    
    
    
}
//MARK: - collectionView

extension RMSearchView : UICollectionViewDelegate , UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - RMSearchInputViewDelegate
extension RMSearchView : RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}
