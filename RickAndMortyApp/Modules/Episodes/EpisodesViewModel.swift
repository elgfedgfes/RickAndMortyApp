//
//  EpisodesViewModel.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import Foundation

protocol EpisodesViewModelDelegate: AnyObject {
    func notifyNotFoundEpisodes()
}

class EpisodesViewModel {
    var networkManager = NetworkManager()
    weak var delegate: EpisodesViewModelDelegate?
    var refreshData = { () -> () in}
    var episodes: [EpisodesModel] = [] {
        didSet {
            refreshData()
        }
    }
    
    func getEpisodes() {
        let url = URLsHelper.rickAndMortyEpisodes
        makeEpisodeRequest(urlRequest: url)
    }
    
    func getFilterEpisodes(searchText: String) {
        let filterUrl = URLsHelper.rickAndMortyEpisodes + "/?name=\(searchText)"
        makeEpisodeRequest(urlRequest: filterUrl)
    }
    
    private func makeEpisodeRequest(urlRequest: String) {
        networkManager.request(url: urlRequest, method: .get, responseType: EpisodesModelResponse.self) { [weak self] modelResponse in
            let responseEpisodes = modelResponse.results?.map {
                EpisodesModel(name: $0.name, airDate: $0.airDate, episode: $0.episode)
            }
            self?.episodes = responseEpisodes ?? []
        } failure: { [weak self] errorResponse in
            if errorResponse.message == "not found" {
                self?.delegate?.notifyNotFoundEpisodes()
            } else {
                print("Error \(errorResponse)")
            }
        }
    }
}
