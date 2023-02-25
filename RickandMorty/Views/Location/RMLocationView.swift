//
//  RMLocationView.swift
//  RickandMorty
//
//  Created by ezz on 21/02/2023.
//

import UIKit

protocol RMLocationViewDelegate : AnyObject {
    func rmLocationView(_ locationView : RMLocationView , didSelect location : RMlocation)
}

final class RMLocationView: UIView {
    
    public weak var delegate : RMLocationViewDelegate?
    
    
    private var viewModel : RMLocationViewViewModel? {
        didSet{
            spinner.stopAnimating()
            tablView.isHidden = false
            tablView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tablView.alpha = 1
            }
        }
    }
    
    private let tablView : UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        tableView.alpha = 0
        tableView.isHidden = true
        return tableView
    }()
    
    
    private let spinner : UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tablView , spinner)
        spinner.startAnimating()
        applayConstraints()
        configureTable()
    }
    required init?(coder: NSCoder) {
        fatalError("No Supported")
    }
    
    private func configureTable(){
        tablView.dataSource = self
        tablView.delegate = self
        tablView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
    }
    
    private func applayConstraints(){
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            tablView.rightAnchor.constraint(equalTo: rightAnchor),
            tablView.leftAnchor.constraint(equalTo: leftAnchor),
            tablView.topAnchor.constraint(equalTo: topAnchor),
            tablView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    ///This is Connection between View and ViewModel ....
    public func configure(with ViewModel : RMLocationViewViewModel){
        self.viewModel = ViewModel
    }

}
extension RMLocationView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else {
            fatalError()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier , for: indexPath) as? RMLocationTableViewCell else {
           fatalError()
        }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ///Notify Controller of selection
       
        guard let locationModel = viewModel?.location(at: indexPath.row) else {
            return
        }
        delegate?.rmLocationView(self,
                                 didSelect: locationModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
