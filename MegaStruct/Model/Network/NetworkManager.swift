//
//  NetworkManager.swift
//  MegaStruct
//
//  Created by 김정호 on 4/23/24.
//

import Foundation

enum HeaderTitle {
    case upcoming
    case nowPlaying
    case popular
    case topRated
}

final class NetworkManager {
    
    // MARK: - properties
    
    // singleton
    static let shared = NetworkManager()
    private init() { }
    
    // header
    private let authorization = Bundle.main.infoDictionary?["APIKey"] as! String
    private let accept = "application/json"
    
    // scheme
    private let scheme = "https"
    
    // host
    private let movieHost = "api.themoviedb.org"
    private let moviePosterHost = "image.tmdb.org"
    
    // path
    private let upcomingMoviePath = "/3/movie/upcoming"
    private let nowPlayingMoviePath = "/3/movie/now_playing"
    private let popularMoviePath = "/3/movie/popular"
    private let topRatedMoviePath = "/3/movie/top_rated"
    private let moviePosterPath = "/t/p/w500"
    private let searchMoviePath = "/3/search/movie"
    
    // MARK: - methods
    func fetchMovieList(category: HeaderTitle, language: String, page: Int, completion: @escaping ((Result<Response, Error>) -> Void)) {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = self.scheme
        urlComponents.host = self.movieHost
        
        switch category {
        case .upcoming:
            urlComponents.path = self.upcomingMoviePath
        case .nowPlaying:
            urlComponents.path = self.nowPlayingMoviePath
        case .popular:
            urlComponents.path = self.popularMoviePath
        case .topRated:
            urlComponents.path = self.topRatedMoviePath
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "language", value: "\(language)"), URLQueryItem(name: "page", value: "\(page)")]
        
        guard let url = urlComponents.url else {
            // completion(.failure(<#T##Error#>))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("\(self.authorization)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.accept)", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                // completion(.failure(<#T##Error#>))
                return
            }
            
            guard let data else {
                // completion(.failure(<#T##Error#>))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response))
            } catch {
                // completion(.failure(<#T##Error#>))
            }
        }
        
        task.resume()
    }
    
    func fetchUrlImage(url: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = self.scheme
        urlComponents.host = self.moviePosterHost
        urlComponents.path = self.moviePosterPath + url
        
        guard let url = urlComponents.url else {
            // completion(.failure(<#T##Error#>))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("\(self.authorization)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.accept)", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                // completion(.failure(<#T##Error#>))
                return
            }
            
            guard let data else {
                // completion(.failure(<#T##Error#>))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func fetchSearchResult(page: Int, searchKeyword: String, completion: @escaping ((Result<Response, Error>) -> Void)) {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = self.scheme
        urlComponents.host = self.movieHost
        urlComponents.path = self.searchMoviePath
        
        urlComponents.queryItems = [URLQueryItem(name: "language", value: "ko"), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "query", value: searchKeyword), URLQueryItem(name: "include_adult", value: "false")]
        
        guard let url = urlComponents.url else {
            // completion(.failure(<#T##Error#>))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("\(self.authorization)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.accept)", forHTTPHeaderField: "accept")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                do {
                    let product = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(product))
                } catch {
                    completion(.failure(error))
                    print("Decode Error: \(error)")
                }
            }
        }
        task.resume()
    }
}
