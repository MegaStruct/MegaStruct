//
//  DetailViewController.swift
//  MegaStruct
//
//  Created by 김정호 on 4/26/24.
//

import UIKit

final class DetailViewController: UIViewController {

    // MARK: - properties
    private let detailView = DetailView()
    private let networkManager = NetworkManager.shared
    
    private var movie: Movie?
    private var posterData: Data?
    private var backdropData: Data?
    
    // MARK: - life cycles
    override func loadView() {
        view = self.detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureAddTarget()
    }
    
    // MARK: - methods
    private func configureUI() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [ .large()]
        }
        sheetPresentationController?.prefersGrabberVisible = true
    }
    
    private func configureAddTarget() {
        detailView.ticketingButton.addTarget(self, action: #selector(didTappedTicketingButton), for: .touchUpInside)
    }
    
    @objc private func didTappedTicketingButton() {
        let ticketingSB = UIStoryboard(name: "TicketingView", bundle: nil)
        guard let ticketingVC = ticketingSB.instantiateViewController(withIdentifier: "TicketingVC") as? TicketingController else { return }
        ticketingVC.movie = movie
        
        present(ticketingVC, animated: true)
    }
    
    func bind(movie: Movie) {
        self.movie = movie
        
        let dispatchGroup = DispatchGroup()
        
        fetchPosterData(group: dispatchGroup)
        fetchBackdropData(group: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.detailView.bind(movie: movie, backdropData: self?.backdropData, posterData: self?.posterData)
        }
    }
    
    private func fetchPosterData(group: DispatchGroup) {
        group.enter()
        
        if let posterPath = movie?.posterPath, !posterPath.isEmpty {
            networkManager.fetchUrlImage(url: posterPath) { result in
                switch result {
                case .success(let data):
                    self.posterData = data
                case .failure(let error):
                    print(error.localizedDescription)
                }
                group.leave()
            }
        } else {
            group.leave()
        }
    }
    
    private func fetchBackdropData(group: DispatchGroup) {
        group.enter()
        
        if let backdropPath = movie?.backdropPath, !backdropPath.isEmpty {
            networkManager.fetchUrlImage(url: backdropPath) { result in
                switch result {
                case .success(let data):
                    self.backdropData = data
                case .failure(let error):
                    print(error.localizedDescription)
                }
                group.leave()
            }
        } else {
            group.leave()
        }
    }
}
