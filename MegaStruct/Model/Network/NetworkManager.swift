//
//  NetworkManager.swift
//  MegaStruct
//
//  Created by 김정호 on 4/23/24.
//

import Foundation

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
    
    // path
    private let upcomingMoviePath = "/3/movie/upcoming"
    
    // MARK: - methods
    func fetchUpcomingMovieLists(language: String, page: Int, completion: @escaping ((Result<Response, Error>) -> Void)) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.movieHost
        urlComponents.path = self.upcomingMoviePath
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
}
