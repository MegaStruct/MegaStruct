//
//  MainViewController.swift
//  MegaStruct
//
//  Created by 김정호 on 4/24/24.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - properties
    private let mainView = MainView()
    
    private let networkManager = NetworkManager.shared
    
    private var upcomingMovies = [Movie]()
    private var nowPlayingMovies = [Movie]()
    private var popularMovies = [Movie]()
    private var topRatedMovies = [Movie]()
    
    // MARK: - life cycles
    override func loadView() {
        view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureData()
        configureCollectionView()
    }
    
    // MARK: - methods
    private func configureUI() {
        self.tabBarController?.tabBar.setUpUITabBar()
    }
    
    private func configureData() {
        let dispatchGroup = DispatchGroup()
        
        fetchUpcomingMovieList(group: dispatchGroup)
        fetchNowPlayingMovieList(group: dispatchGroup)
        fetchPopularMovieList(group: dispatchGroup)
        fetchTopRatedMovieList(group: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.mainView.collectionView.reloadData()
        }
    }
    
    private func fetchUpcomingMovieList(group: DispatchGroup) {
        group.enter()
        
        networkManager.fetchMovieList(category: .upcoming, language: "ko", page: 1) { result in
            switch result {
            case .success(let data):
                self.upcomingMovies = data.results
            case .failure(let error):
                self.printError(error)
            }
            group.leave()
        }
    }
    
    private func fetchNowPlayingMovieList(group: DispatchGroup) {
        group.enter()
        
        networkManager.fetchMovieList(category: .nowPlaying, language: "ko", page: 1) { result in
            switch result {
            case .success(let data):
                self.nowPlayingMovies = data.results
            case .failure(let error):
                self.printError(error)
            }
            group.leave()
        }
    }
    
    private func fetchPopularMovieList(group: DispatchGroup) {
        group.enter()
        
        networkManager.fetchMovieList(category: .popular, language: "ko", page: 1) { result in
            switch result {
            case .success(let data):
                self.popularMovies = data.results
            case .failure(let error):
                self.printError(error)
            }
            group.leave()
        }
    }
    
    private func fetchTopRatedMovieList(group: DispatchGroup) {
        group.enter()
        
        networkManager.fetchMovieList(category: .topRated, language: "ko", page: 1) { result in
            switch result {
            case .success(let data):
                self.topRatedMovies = data.results
            case .failure(let error):
                self.printError(error)
            }
            group.leave()
        }
    }
    
    private func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        mainView.collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MainHeaderView")
        mainView.collectionView.register(MainFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MainFooterView")
    }
    
    private func printError(_ error: Error) {
        switch error {
        case NetworkError.urlConversionFailure:
            print("Url 변환 실패")
        case NetworkError.dataFailure:
            print("네트워크 오류")
        case NetworkError.jsonDecodingFailure:
            print("Json Decoding 실패")
        default:
            print(error.localizedDescription)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        
        switch indexPath.section {
        case 0:
            detailVC.bind(movie: upcomingMovies[indexPath.row])
        case 1:
            detailVC.bind(movie: nowPlayingMovies[indexPath.row])
        case 2:
            detailVC.bind(movie: popularMovies[indexPath.row])
        default:
            detailVC.bind(movie: topRatedMovies[indexPath.row])
        }
        
        present(detailVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainHeaderView", for: indexPath) as? MainHeaderView else {
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case 0:
                header.prepare(text: "Upcoming")
            case 1:
                header.prepare(text: "Now playing")
            case 2:
                header.prepare(text: "Popular")
            default:
                header.prepare(text: "Top rated")
            }
            
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainFooterView", for: indexPath) as? MainFooterView else {
                return UICollectionReusableView()
            }
            
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return upcomingMovies.count
        case 1:
            return nowPlayingMovies.count
        case 2:
            return popularMovies.count
        default:
            return topRatedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            if let posterPath = upcomingMovies[indexPath.row].posterPath {
                networkManager.fetchUrlImage(url: posterPath) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.bind(movie: self.upcomingMovies[indexPath.row], imageData: data)
                        }
                    case .failure(let error):
                        self.printError(error)
                        
                        DispatchQueue.main.async {
                            cell.bind(movie: self.upcomingMovies[indexPath.row], imageData: nil)
                        }
                    }
                }
            } else {
                cell.bind(movie: self.upcomingMovies[indexPath.row], imageData: nil)
            }
        case 1:
            if let posterPath = nowPlayingMovies[indexPath.row].posterPath {
                networkManager.fetchUrlImage(url: posterPath) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.bind(movie: self.nowPlayingMovies[indexPath.row], imageData: data)
                        }
                    case .failure(let error):
                        self.printError(error)
                        
                        DispatchQueue.main.async {
                            cell.bind(movie: self.nowPlayingMovies[indexPath.row], imageData: nil)
                        }
                    }
                }
            } else {
                cell.bind(movie: self.nowPlayingMovies[indexPath.row], imageData: nil)
            }
        case 2:
            if let posterPath = popularMovies[indexPath.row].posterPath {
                networkManager.fetchUrlImage(url: posterPath) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.bind(movie: self.popularMovies[indexPath.row], imageData: data)
                        }
                    case .failure(let error):
                        self.printError(error)
                        
                        DispatchQueue.main.async {
                            cell.bind(movie: self.popularMovies[indexPath.row], imageData: nil)
                        }
                    }
                }
            } else {
                cell.bind(movie: self.popularMovies[indexPath.row], imageData: nil)
            }
        default:
            if let posterPath = topRatedMovies[indexPath.row].posterPath {
                networkManager.fetchUrlImage(url: posterPath) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.bind(movie: self.topRatedMovies[indexPath.row], imageData: data)
                        }
                    case .failure(let error):
                        self.printError(error)
                        
                        DispatchQueue.main.async {
                            cell.bind(movie: self.topRatedMovies[indexPath.row], imageData: nil)
                        }
                    }
                }
            } else {
                cell.bind(movie: self.topRatedMovies[indexPath.row], imageData: nil)
            }
        }
        
        return cell
    }
}
