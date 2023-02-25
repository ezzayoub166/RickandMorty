//
//  RMCharacterListViewCollectionViewCell.swift
//  RickandMorty
//
//  Created by ezz on 04/02/2023.
//

import UIKit

///Signle cell for a Character

class RMCharacterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RMCharacterCollectionViewCell"
    
    private let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLable : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    
    private let statusLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    private func applayConstraints(){
        contentView.addSubviews(imageView , nameLable , statusLabel)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLable.topAnchor , constant: -3),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLable.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -3),
            nameLable.bottomAnchor.constraint(equalTo: statusLabel.topAnchor)
        
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayers()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applayConstraints()
        setUpLayers()
    }
    
    private func setUpLayers(){
        contentView.backgroundColor = .systemGroupedBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor =  UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLable.text = nil
        statusLabel.text = nil
    }
    public func configure(with model : RMCharacterCollectionViewCellViewModel){
        nameLable.text = model.characterName
        statusLabel.text = model.characterStatusText
        model.fetchImage { [weak self]result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
