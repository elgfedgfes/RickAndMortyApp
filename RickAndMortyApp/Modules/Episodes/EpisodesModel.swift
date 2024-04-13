//
//  EpisodesModel.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import Foundation

struct EpisodesModel {
    let name: String?
    let airDate: String?
    let episode: String?
}

struct EpisodesModelResponse: Codable {
    let info: Info?
    let results: [EpisodesResult]?
}


// MARK: - Result
struct EpisodesResult: Codable {
    let id: Int?
    let name: String?
    let airDate: String?
    let episode: String?
    let characters: [String]?
    let url: String?
    let created: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }
}
