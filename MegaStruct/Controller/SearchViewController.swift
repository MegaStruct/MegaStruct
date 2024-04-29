//
//  SearchViewController.swift
//  MegaStruct
//
//  Created by 신지연 on 2024/04/24.
//

import Foundation
import UIKit

class SearchViewController: UIViewController{
    
    private var searchList: [String] = []
    private var searchWord = ""
    private var searchResult: Response = Response(page: 0, results: [], totalPages: 0, totalResults: 0)
    private var movieResult: [Movie] = []
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    private var page = 1
    
    
    // MARK: - view
    // Top
    let searchView: UIView = {
        let bgview = UIView()
        bgview.layer.shadowColor = UIColor.black.cgColor
        bgview.layer.shadowOpacity = 0.6
        bgview.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgview.layer.shadowRadius = 5
        bgview.layer.masksToBounds = false
        bgview.layer.shouldRasterize = false
        bgview.backgroundColor = UIColor.white
        bgview.layer.borderWidth = 1
        bgview.layer.borderColor = UIColor.clear.cgColor
        bgview.layer.cornerRadius = 20
        return bgview
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "영화를 검색해보세요"
        search.searchBarStyle = .minimal
        search.searchTextField.borderStyle = .none
        search.delegate = self
        if let tf = search.value(forKey: "searchField") as? UITextField {
            if let leftView = tf.leftView as? UIImageView {
                leftView.tintColor = .megaRed
            }
        }
        return search
    }()
    
    // Body
    let lastSearchedView: UIView = UIView()
    
    private let lastSearchedLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Searched"
        label.textColor = .megaRed
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var btnDeleteCompletely: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tintColor = .megaRed
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let lastSearchedCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        return layout
    }()
    
    lazy var lastSearchedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: lastSearchedCollectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LastSearchedCell.self, forCellWithReuseIdentifier: "LastSearchedCell")
        return collectionView
    }()
    
    let resultView: UIView = UIView()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var cardContent: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: "SearchViewCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var customLoadingView: UIView = {
        let backview = UIView()
        backview.frame = CGRect(x: 0, y: 0, width: 100, height: 150)
        backview.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "Loading"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 35, y: 60, width: 30, height: 30)
        backview.addSubview(imageView)
        return backview
    }()
    
    var customNoPosterView: UIView = {
        let backview = UIView()
        backview.frame = CGRect(x: 0, y: 0, width: 100, height: 150)
        backview.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 15, y: 40, width: 70, height: 70)
        backview.addSubview(imageView)
        return backview
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad(){
        super.viewDidLoad()
        getLastSearch()
        setUI()
        fetchTrendingResults()
        view.backgroundColor = .white
    }
    
    // MARK: - function
    func setUI(){
        self.view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchView.widthAnchor.constraint(equalToConstant: 340),
            searchView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        self.searchView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchBar.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: 320)
        ])
        if searchList.isEmpty {
            print("검색기록이 없음")
            noLastSearchList()
        } else {
            print("검색기록이 있음")
            haveLastSearchList()
        }
    }
    
    @objc func deleteButtonTapped(){
        let alertController = UIAlertController(title: "검색어를 삭제하시겠습니까?", message: "삭제 클릭시 최근 검색어가 삭제됩니다.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            lastSearchedView.removeFromSuperview()
            resultView.removeFromSuperview()
            for word in searchList {
                delLastSearch(word)
            }
            searchList.removeAll()
            noLastSearchList()
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func haveLastSearchList() {
        self.view.addSubview(lastSearchedView)
        lastSearchedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastSearchedView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            lastSearchedView.heightAnchor.constraint(equalToConstant: 100),
            lastSearchedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lastSearchedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.lastSearchedView.addSubview(lastSearchedLabel)
        lastSearchedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastSearchedLabel.topAnchor.constraint(equalTo: lastSearchedView.topAnchor, constant: 10),
            lastSearchedLabel.leadingAnchor.constraint(equalTo: lastSearchedView.leadingAnchor, constant: 20)
        ])
        
        self.lastSearchedView.addSubview(btnDeleteCompletely)
        btnDeleteCompletely.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnDeleteCompletely.centerYAnchor.constraint(equalTo: lastSearchedLabel.centerYAnchor),
            btnDeleteCompletely.trailingAnchor.constraint(equalTo: lastSearchedView.trailingAnchor, constant: -20)
        ])
        
        self.lastSearchedView.addSubview(lastSearchedCollectionView)
        lastSearchedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastSearchedCollectionView.topAnchor.constraint(equalTo: lastSearchedLabel.bottomAnchor),
            lastSearchedCollectionView.leadingAnchor.constraint(equalTo: lastSearchedLabel.leadingAnchor),
            lastSearchedCollectionView.trailingAnchor.constraint(equalTo: lastSearchedView.trailingAnchor),
            lastSearchedCollectionView.bottomAnchor.constraint(equalTo: lastSearchedView.bottomAnchor, constant: -10)
        ])
        
        self.view.addSubview(resultView)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: lastSearchedView.bottomAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.resultView.addSubview(cardContent)
        cardContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardContent.topAnchor.constraint(equalTo: resultView.topAnchor),
            cardContent.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
            cardContent.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 10),
            cardContent.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -10)
        ])
    }
    
    func noLastSearchList() {
        self.view.addSubview(resultView)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 20),
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.resultView.addSubview(cardContent)
        cardContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardContent.topAnchor.constraint(equalTo: resultView.topAnchor),
            cardContent.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
            cardContent.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 10),
            cardContent.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -10)
        ])
    }
    
    func addLastSearch() {
        coreDataManager.saveRecentSearch(idx: 1, keyword: searchWord) { [weak self] result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self?.lastSearchedCollectionView.reloadData()
                }
            case false:
                print("추가 안됨.")
            }
        }
    }
    
    func getLastSearch() {
        let searchWords = coreDataManager.fetchSearchData()
        searchList = []
        for words in searchWords {
            if let term = words.value(forKey: "keyword") as? String {
                searchList.append(term)
            }
        }
    }
    
    func delLastSearch(_ delWord: String){
        coreDataManager.delSearchData(word: delWord) { [weak self] result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self?.lastSearchedCollectionView.reloadData()
                }
            case false:
                print("delLastSearch()에서 에러남")
            }
        }
    }
    
    func fetchTrendingResults() {
        print("트렌딩")
        networkManager.fetchMovieList(category: .popular, language: "ko", page: 1) { result in
            switch result {
            case .success(let data):
                self.searchResult = data
                self.movieResult = data.results
                DispatchQueue.main.async {
                    self.cardContent.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateSearchResults() {
        print("결과update")
        networkManager.fetchSearchResult(page: 1, searchKeyword: searchWord) {  [weak self] result in
            switch result {
            case .success(let response):
                self?.searchResult = response
                self?.movieResult = response.results
                DispatchQueue.main.async {
                    self?.cardContent.reloadData()
                }
            case .failure(let error):
                print("updateSearchREsults()에서 에러남")
            }
        }
    }
    
    func loadTrendingMore() {
        if page <= searchResult.totalPages! {
            page += 1
            
            networkManager.fetchMovieList(category: .popular, language: "ko", page: page) { result in
                switch result {
                case .success(let data):
                    let startIndex = self.movieResult.count - 1 // 새로운 아이템의 시작 인덱스
                    let endIndex =  self.movieResult.count + data.results.count // 새로운 아이템의 끝 인덱스
                    self.movieResult += data.results
                    var newIndexPaths: [IndexPath] = []
                    for index in startIndex..<endIndex {
                        let indexPath = IndexPath(row: index, section: 0)
                        newIndexPaths.append(indexPath)
                    }
                    DispatchQueue.main.async {
                        self.cardContent.reloadData()
                        //self.cardContent.reloadItems(at: newIndexPaths)
                        //self.cardContent.reconfigureItems(at: newIndexPaths)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadSearchMore() {
        if page <= searchResult.totalPages! {
            page += 1
            networkManager.fetchSearchResult(page: page, searchKeyword: searchWord) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    let startIndex = self.movieResult.count - 1 // 새로운 아이템의 시작 인덱스
                    let endIndex =  self.movieResult.count + response.results.count // 새로운 아이템의 끝 인덱스
                    self.movieResult += response.results
                    var newIndexPaths: [IndexPath] = []
                    for index in startIndex..<endIndex {
                        let indexPath = IndexPath(row: index, section: 0)
                        newIndexPaths.append(indexPath)
                    }
                    DispatchQueue.main.async {
                        self.cardContent.reloadData()
                        //self.cardContent.reloadItems(at: newIndexPaths)
                        //self.cardContent.reconfigureItems(at: newIndexPaths)
                    }
                case .failure(let error):
                    print("loadMore 에러")
                }
            }
        }
    }
}

// MARK: - extension
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("사용자가 입력한 텍스트: \(searchText)")
        searchWord = searchText
        if searchText == "" {
            fetchTrendingResults()
        } else {
            updateSearchResults()
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("사용자가 엔터 키를 눌렀습니다.")
        searchBar.resignFirstResponder()
        if let keyword = searchBar.text {
            searchList.append(keyword)
            searchWord = keyword
            addLastSearch()
        }
        resultView.removeFromSuperview()
        haveLastSearchList()
        lastSearchedCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchTrendingResults()
        searchBar.text = ""
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardContent {
            return movieResult.count
        } else {
            return searchList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cardContent {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchViewCell", for: indexPath) as? SearchViewCell else { return UICollectionViewCell() }
            cell.contentLabel.text = movieResult[indexPath.row].title
            
            // 로딩 이미지 설정
            cell.movieImage.image = customLoadingView.asImage()
            
            if let url = movieResult[indexPath.row].posterPath {
                networkManager.fetchUrlImage(url: url) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.movieImage.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        cell.movieImage.image = self.customNoPosterView.asImage()
                    }
                }
            }else {
                cell.movieImage.image = customNoPosterView.asImage()
            }
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastSearchedCell", for: indexPath) as? LastSearchedCell else { return UICollectionViewCell() }
            cell.lastSearchLabel.text = searchList[indexPath.row]
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cardContent {
            return CGSize(width: 110, height: 175)
        } else {
            let text = searchList[indexPath.row]
            let font = UIFont.systemFont(ofSize: 20)
            let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: font]).width
            let cellWidth = textWidth + 15
            return CGSize(width: cellWidth, height: 36)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardContent {
            let detailVC = DetailViewController()
            detailVC.bind(movie: movieResult[indexPath.row])
            present(detailVC, animated: true)
        }else {
            let text = searchList[indexPath.row]
            searchBar.searchTextField.text = text
            if let keyword = searchBar.text {
                searchWord = keyword
                searchList.append(searchWord)
                updateSearchResults()
                searchList.remove(at: indexPath.row)
                delLastSearch(keyword)
                addLastSearch()
                getLastSearch()
                lastSearchedCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movieResult.count - 1{
            if searchWord == "" {
                loadTrendingMore()
            } else {
                loadSearchMore()
            }
        }
    }
}

extension UIView {
  func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
