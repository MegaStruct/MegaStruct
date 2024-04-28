//
//  LastSearchedCell.swift
//  MegaStruct
//
//  Created by 신지연 on 2024/04/24.
//

import UIKit

class LastSearchedCell: UICollectionViewCell {
    
    let lastSearchLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
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
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.megaRed.cgColor
        
        contentView.addSubview(lastSearchLabel)
        lastSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastSearchLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lastSearchLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        layer.masksToBounds = true
    }
}
