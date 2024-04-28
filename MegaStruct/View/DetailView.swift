//
//  DetailView.swift
//  MegaStruct
//
//  Created by 김정호 on 4/26/24.
//

import UIKit
import Cosmos
import SnapKit

final class DetailView: UIView {
    
    // MARK: - properties
    private let genres = [(12, "모험"), (14, "판타지"), (16, "애니메이션"), (18, "드라마"), (27, "공포"), (28, "액션"), (35, "코미디"),
                          (36, "역사"), (37, "웨스턴"), (53, "스릴러"), (80, "범죄"), (99, "다큐멘터리"), (878, "SF"), (9648, "미스테리"),
                          (10402, "음악"), (10749, "로맨스"), (10751, "가족"), (10752, "전쟁"), (10770, "TV")]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(resource: .logo)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.megaRed.cgColor
        imageView.alpha = 0.8
        return imageView
    }()
    
    private let backdropImageTintingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(resource: .logo)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.megaRed.cgColor
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, originalTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var releaseDateAndGenresStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [releaseDateLabel, genresLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let starRatingView: CosmosView = {
        let cosmosView = CosmosView()
        
        // touch
        cosmosView.settings.updateOnTouch = false
        
        // star
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.starSize = 20
        cosmosView.settings.starMargin = 0.1
        cosmosView.settings.emptyBorderWidth = 2
        
        // star color
        cosmosView.settings.filledColor = UIColor.megaRed
        cosmosView.settings.emptyBorderColor = UIColor.megaRed
        cosmosView.settings.filledBorderColor = UIColor.megaRed
        
        // text
        cosmosView.settings.textMargin = 8
        cosmosView.settings.textFont = UIFont.systemFont(ofSize: 16, weight: .medium)
 
        // text color
        cosmosView.settings.textColor = .lightGray
        
        return cosmosView
    }()
    
    private let divisionLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 222/255, green: 226/255, blue: 230/255, alpha: 1).cgColor
        return view
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let ticketingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .megaRed
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.setTitle("예매하기", for: .normal)
        button.configuration = UIButton.Configuration.plain()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        return button
    }()
    
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
    }
    
    private func configureConstraint() {
        self.addSubview(scrollView)
        self.addSubview(ticketingButton)
        self.scrollView.addSubview(scrollContentView)
        self.scrollContentView.addSubview(backdropImageView)
        self.scrollContentView.addSubview(backdropImageTintingView)
        self.scrollContentView.addSubview(posterImageView)
        self.scrollContentView.addSubview(titleStackView)
        self.scrollContentView.addSubview(releaseDateAndGenresStackView)
        self.scrollContentView.addSubview(starRatingView)
        self.scrollContentView.addSubview(divisionLineView)
        self.scrollContentView.addSubview(overviewLabel)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.ticketingButton.snp.top).inset(-4)
        }
        
        ticketingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        backdropImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.backdropImageView.snp.width).offset(-20)
        }
        
        backdropImageTintingView.snp.makeConstraints {
            $0.edges.equalTo(self.backdropImageView.snp.edges)
        }
        
        posterImageView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.bottom.equalTo(self.backdropImageView.snp.bottom).inset(20)
            $0.width.equalTo(120)
            $0.height.equalTo(170)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(self.posterImageView.snp.top)
            $0.leading.equalTo(self.posterImageView.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
        
        releaseDateAndGenresStackView.snp.makeConstraints {
            $0.top.equalTo(self.titleStackView.snp.bottom).offset(6)
            $0.leading.equalTo(self.posterImageView.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
        
        starRatingView.snp.makeConstraints {
            $0.top.equalTo(self.releaseDateAndGenresStackView.snp.bottom).offset(12)
            $0.leading.equalTo(self.posterImageView.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
        
        divisionLineView.snp.makeConstraints {
            $0.top.equalTo(self.backdropImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(self.divisionLineView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind(movie: Movie, backdropData: Data?, posterData: Data?) {
        if let backdropData = backdropData {
            backdropImageView.image = UIImage(data: backdropData)
            backdropImageView.layer.borderWidth = 0
            backdropImageView.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let posterData = posterData {
            posterImageView.image = UIImage(data: posterData)
            posterImageView.layer.borderWidth = 0
            posterImageView.layer.borderColor = UIColor.clear.cgColor
        }
        
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        
        if let releaseDate = movie.releaseDate {
            releaseDateLabel.text = releaseDate.replaceReleaseDate() + " 개봉"
        }
        
        for genre in movie.genreIDS {
            if genresLabel.text == nil {
                genresLabel.text = genres.filter { $0.0 == genre }.first?.1
            } else if let genresLabelText = genresLabel.text, !genresLabelText.isEmpty {
                genresLabel.text = genresLabelText + ", " + (genres.filter { $0.0 == genre }.first?.1 ?? "")
            }
        }
        
        starRatingView.rating = (movie.voteAverage ?? 0.0) / 2.0
        
        if let voteAverage = movie.voteAverage {
            starRatingView.text = String(format: "%.1f", voteAverage / 2.0)
        } else {
            starRatingView.text = "0.0"
        }
        
        overviewLabel.attributedText = movie.overview?.setLineSpacing(20)
    }
}
