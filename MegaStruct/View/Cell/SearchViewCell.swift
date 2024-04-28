//
//  SearchViewCell.swift
//  MegaStruct
//
//  Created by 신지연 on 2024/04/24.
//

import UIKit

class SearchViewCell: UICollectionViewCell {
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(movieImage)
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 155),
            movieImage.widthAnchor.constraint(equalToConstant: 115),
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 2),
            contentLabel.widthAnchor.constraint(equalToConstant: 110)
        ])
        layer.masksToBounds = true
    }
}
