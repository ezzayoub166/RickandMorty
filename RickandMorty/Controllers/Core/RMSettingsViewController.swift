//
//  RMSettingsViewController.swift
//  RickandMorty
//
//  Created by ezz on 02/02/2023.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

final class RMSettingsViewController: UIViewController {
    
    
    private var settingsSwiftUIContoller : UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIContoller()

    }
    
    private func addSwiftUIContoller(){
        
        let settingsSwiftUIContoller = UIHostingController(
            rootView: RMSettingsView(viewModle: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({return RMSettingsCellViewModel(type: $0) { [weak self]option in
                self?.handleTap(option: option)
            }}))))
        
        
        addChild(settingsSwiftUIContoller)
        settingsSwiftUIContoller.didMove(toParent: self)
        view.addSubview(settingsSwiftUIContoller.view)
        settingsSwiftUIContoller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIContoller.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIContoller.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsSwiftUIContoller.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIContoller.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            
        
        ])
        self.settingsSwiftUIContoller = settingsSwiftUIContoller
    }
    
    private func handleTap(option : RMSettingsOption){
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.targetUrl {
            //open website
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        else if option == .rateApp {
            //Show Rating Promt
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
        
    }

}
