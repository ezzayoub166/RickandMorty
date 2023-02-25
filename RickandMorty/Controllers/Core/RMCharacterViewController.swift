//
//  RMCharacterViewController.swift
//  RickandMorty
//
//  Created by ezz on 02/02/2023.
//

import UIKit
class RMCharacterViewController: UIViewController  , RMCharacterListViewDelegate{

    
    
    private let  characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        applayConstratins()
        characterListView.delegate = self
        addSearchButton()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
           target: self,
            action: #selector(didTapSearch)
        )
    }
    @objc
    private func didTapSearch(){
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
    private func applayConstratins(){
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCaracter character: RMCharacter){
        // Open detail Controller for that Character
        let viewModel = RMCharacterDetailsViewModel(character: character)
        let detailVC = RMCharacterDetailsViewController(viewMoedl: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

