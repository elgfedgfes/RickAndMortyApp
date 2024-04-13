//
//  CharactersViewModel.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import UIKit

protocol CharactersViewModelDelegate: AnyObject {
    func notifyNotFoundCharacters()
}

class CharactersViewModel {
    var networkManager = NetworkManager()
    weak var delegate: CharactersViewModelDelegate?
    var refreshData = { () -> () in}
    var characters: [CharactersModel] = [] {
        didSet {
            refreshData()
        }
    }
    
    func getCharacters() {
        let url = URLsHelper.rickAndMortyCharacters
        makeCharacterRequest(urlRequest: url)
    }
    
    func getFilterCharacters(searchText: String) {
        let filterUrl = URLsHelper.rickAndMortyCharacters + "/?name=\(searchText)"
        makeCharacterRequest(urlRequest: filterUrl)
    }
    
    private func makeCharacterRequest(urlRequest: String) {
        networkManager.request(url: urlRequest, method: .get, responseType: CharactersModelResponse.self) { [weak self] modelResponse in
            let responseCharacters = modelResponse.results?.map {
                CharactersModel(name: $0.name, status: $0.status, imageURL: $0.image)
            }
            self?.characters = responseCharacters ?? []
        } failure: { [weak self] errorResponse in
            if errorResponse.message == "not found" {
                self?.delegate?.notifyNotFoundCharacters()
            } else {
                print("Error \(errorResponse)")
            }
        }
    }
}
