//
//  RMEpisodeViewController.swift
//  RickandMorty
//
//  Created by ezz on 02/02/2023.
//

import UIKit

final class RMEpisodeViewController: UIViewController , RMEpisodeListViewDelegate {
    
    func rmEpisodeListView(_ epiosdeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open detail Controller for that Episode
        let viewModel = RMEpisodeDetailsViewViewModel(endpointUrl: URL(string: episode.url))
        let detailVC = RMEpisodeDetailsViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private let  episodeListView = RMEpisodeListView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        applayConstratins()
        episodeListView.delegate = self
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
        let vc = RMSearchViewController(config: RMSearchViewController.Config.init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc
                                                 , animated: true)
        
    }
    
    private func applayConstratins(){
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    
}
