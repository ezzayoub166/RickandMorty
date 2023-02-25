//
//  RMSearchViewController.swift
//  RickandMorty
//
//  Created by ezz on 14/02/2023.
//

import UIKit

//Dynamic search option view
//Render Results
//Render No Results
//Searching / API Call



///Configruble Controller to Seacrh
final class RMSearchViewController: UIViewController {
    
    private let searchView : RMSearchView
    private let viewModel : RMSearchViewViewModel
    
    struct Config {
        enum `Type` {
            case character //Name | status | gender
            case episode //name
            case location // name | type
            
            var displayTitle : String {
                switch self {
                case .character: return "Search Characters"
                case .episode : return "Search Episodes"
                case .location: return "Search Locations"
                }
            }
        }
        let type : `Type`
    }
    
    init(config : Config){
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        applayConstraints()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.displayTitle
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        applayConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch)
        )
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    @objc
    private func didTapExecuteSearch(){
//        viewModel.execureSearch()
    }
    
    //MARK: privte
    
    private func applayConstraints(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        
        
        ])
    }
}
extension RMSearchViewController : RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        print("Should present option picker ")
    }
    
    
}
