//
//  URLsHelper.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import Foundation

enum APIBasePath: String {
    case base = "https://rickandmortyapi.com/api/"
}

enum Endpoint: String {
    case characters = "character"
    case episodes = "episode"
}

class URLsHelper {
    static let rickAndMortyCharacters = (APIBasePath.base.rawValue + Endpoint.characters.rawValue)
    static let rickAndMortyEpisodes = (APIBasePath.base.rawValue + Endpoint.episodes.rawValue)
    
    func appendNameQueryParameter(url: String, name: String) -> String {
        guard var urlComponents = URLComponents(string: url + "/") else {
            return url
        }
        urlComponents.queryItems = [URLQueryItem(name: "name", value: name)]
        guard let nonNilURL = urlComponents.url else {
            return url
        }
        return nonNilURL.absoluteString
    }
}
