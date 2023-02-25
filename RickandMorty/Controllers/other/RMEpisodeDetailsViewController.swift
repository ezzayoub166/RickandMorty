//
//  RMEpisodeDetailsViewController.swift
//  RickandMorty
//
//  Created by ezz on 12/02/2023.
//

import UIKit

final class RMEpisodeDetailsViewController: UIViewController , RMEpisodeDetailsViewViewModelDelegate, RMEpisodeDetailsViewDelegate {
    
    //MARK: View Delegate
    func rmEpiseodeDetailView(_ detailView: RMEpisodeDetailsView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailsViewController(viewMoedl: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private let viewModel : RMEpisodeDetailsViewViewModel
    
    private let detailView = RMEpisodeDetailsView()
    
    
    //MARK: init
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailsViewViewModel(endpointUrl: url)
        print("Selected Episode To show Details\(String(describing: url))")
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        applayConstraints()
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
        detailView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    private func applayConstraints() {
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func didFetchEpisodeDetails() {
        detailView.configure(with : viewModel)
    }


}
