//
//  RMLocationDetailsViewController.swift
//  RickandMorty
//
//  Created by ezz on 23/02/2023.
//

import UIKit

final class RMLocationDetailsViewController: UIViewController , RMLocationDetailsViewViewModelDelegate {

    private let location : RMlocation
    
    private let primaryView = RMLocationDetailsView()
    
    private let viewModel : RMLocationDetailsViewViewModel
        
    
    //MARK: - Init
    init(location: RMlocation) {
        self.location = location
        self.viewModel = RMLocationDetailsViewViewModel(location: location)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        applayConstraints()
        title = "Location"
        viewModel.fetchLocationDeatils()
        viewModel.deleagte = self
        
       
        
    }
    
    //MARK: Private
    private func applayConstraints(){
        view.addSubview(primaryView)
        NSLayoutConstraint.activate([
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - RMLocationDetails ViewModel Deleagte
    func didFetchDetailsLocation() {
        primaryView.configure(with: viewModel)
    }
    
}
