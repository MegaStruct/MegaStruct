//
//  MainCollectionViewCell.swift
//  MegaStruct
//
//  Created by 김정호 on 4/24/24.
//

import UIKit
import SnapKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImageView.image = nil
        movieTitleLabel.text = nil
    }
    
    // MARK: - methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        
        self.movieImageView.clipsToBounds = true
        self.movieImageView.layer.cornerRadius = 8
    }
    
    private func configureConstraint() {
        self.addSubview(movieImageView)
        self.addSubview(movieTitleLabel)
        
        movieImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(170)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.movieImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(self.snp.bottom).offset(20)
        }
    }
    
    func bind(movie: Movie, imageData: Data?) {
        movieTitleLabel.text = movie.title
        
        if let imageData = imageData {
            movieImageView.image = UIImage(data: imageData)
        }
    }
}
