//
//  RMCharacterDetailsViewController.swift
//  RickandMorty
//
//  Created by ezz on 05/02/2023.
//

import UIKit

class RMCharacterDetailsViewController: UIViewController {
    
    private let viewModel : RMCharacterDetailsViewModel
    
    private let detailView : RMCharacterDetailView
    
    init(viewMoedl : RMCharacterDetailsViewModel){
        self.viewModel = viewMoedl
        self.detailView =  RMCharacterDetailView(frame: .zero, viewModel: viewMoedl)
        super.init(nibName: nil, bundle: nil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        detailView.collectionView?.dataSource = self
        detailView.collectionView?.delegate = self
    }
    
    
    @objc private func didTapShare(){
        //Share character Info
         
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])

    }

}
//MARK: - collectionView
extension RMCharacterDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModel):
            return viewModel.count
        case .episodes(let viewModel):
            return viewModel.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier,
                for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier,
                for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        case .episodes(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ///Not things to Show
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo , .information :
            break
        case .episodes(let viewModel):
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let vc = RMEpisodeDetailsViewController(url: URL(string: selection))
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
