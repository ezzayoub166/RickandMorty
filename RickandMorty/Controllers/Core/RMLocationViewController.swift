//
//  RMLocationViewController.swift
//  RickandMorty
//
//  Created by ezz on 02/02/2023
import UIKit
class RMLocationViewController: UIViewController , RMLocationViewViewModelDelegate , RMLocationViewDelegate {
 
    
    
    private let primryView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        view.addSubview(primryView)
        applayConstraints()
        viewModel.fetchLocations()
        viewModel.deleagte = self
        primryView.delegate = self
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
        
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .location))

        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc
                                                 , animated: true)
        
    }
    
    private func applayConstraints(){
        NSLayoutConstraint.activate([
            primryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: LocationViewViewModel Deleagte
    // يعني هو هلقيت بعد ما يجيب الداتا ويبعت الريكوستتتت ...راح يروح يعمل توصيل الفيو مع الفيو مودل
    // والفيو مودل راح يكون بيحتوي على العناصر يلي هما لوكيشننن
    //واحنا بنعمل دليحيات مع السلف عشان نجيب هاي الدالة
    func didFetchInitLocations() {
        primryView.configure(with: viewModel)
    }
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMlocation) {
        let vc = RMLocationDetailsViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
