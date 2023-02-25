//
//  CharacterListView.swift
//  RickandMorty
//
//  Created by ezz on 04/02/2023.
//




import UIKit

protocol RMCharacterListViewDelegate : AnyObject {
    func rmCharacterListView (
        _ characterListView : RMCharacterListView,
        didSelectCaracter character : RMCharacter
    )
    
}


final class RMCharacterListView : UIView {
    
    private let viewModel = RMCharacterListViewViewModel()
    
    public weak var delegate : RMCharacterListViewDelegate?
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints =  false
        return spinner
        
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset  = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier)
        collectionView.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter ,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner , collectionView )
        applayConstraints()
        spinner.startAnimating()
        viewModel.fetchCharacters()
        viewModel.delegate = self
        setUpCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applayConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel
        collectionView.delegate  = viewModel
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {

//        }
    }
}

extension RMCharacterListView : RMCharacterListViewViewModelDelegate {
    func didLoadMoreCharacters(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
    
    func didSelectRMCaracter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self,
                                      didSelectCaracter: character)
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Initial Fetch For Characters
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
