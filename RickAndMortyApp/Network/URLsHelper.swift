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
}
