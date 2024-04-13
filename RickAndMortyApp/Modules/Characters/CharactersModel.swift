//
//  CharactersModel.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import Foundation

struct CharactersModel {
    let name: String?
    let status: Status?
    let imageURL: String?
}

struct CharactersModelResponse: Codable {
    let info: Info?
    let results: [CharactersResult]?
}
// MARK: - Info
struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Result
struct CharactersResult: Codable {
    let id: Int?
    let name: String?
    let status: Status?
    let species: String?
    let type: String?
    let gender: Gender?
    let origin: Origin?
    let location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}
// MARK: - Gender
enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

// MARK: - Location
struct Origin: Codable {
    let name: String?
    let url: String?
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
