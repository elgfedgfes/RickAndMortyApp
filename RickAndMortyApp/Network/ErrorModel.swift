//
//  ErrorModel.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import UIKit

enum ErrorCodes {
    static let unknown = "-000001"
    static let badURL = "-000002"
    static let badResponseBody = "-000003"
    static let badRequestBody = "-000004"
    static let noInternet = "-000005"
}

enum DefaultErrorType {
    case unknown
    case badURL
    case badResponseBody
    case badRequestBody
    case noInternet
    
    func getCode() -> String {
        switch self {
        case .unknown:
            return ErrorCodes.unknown
        case .badURL:
            return ErrorCodes.badURL
        case .badResponseBody:
            return ErrorCodes.badResponseBody
        case .badRequestBody:
            return ErrorCodes.badRequestBody
        case .noInternet:
            return ErrorCodes.noInternet
        }
    }
    
    func getTitle() -> String {
        return "Alerts.title".localized
    }
    
    func getMessage() -> String {
        switch self {
        case .unknown:
            return "Network.message.unknown".localized
        case .badURL:
            return "Network.message.badURL".localized
        case .badResponseBody:
            return "Network.message.badResponseBody".localized
        case .badRequestBody:
            return "Network.message.badRequestBody".localized
        case .noInternet:
            return "Network.message.noInternet".localized
        }
    }
}

struct ErrorModel {
    let code: String
    let title: String
    let message: String
    let defaultErrorType: DefaultErrorType?
    
    init(code: String = DefaultErrorType.unknown.getCode(),
         title: String = DefaultErrorType.unknown.getTitle(),
         message: String = DefaultErrorType.unknown.getMessage()) {
        self.code = code
        self.title = title
        self.message = message
        self.defaultErrorType = nil
    }
    
    init(code: String,
         title: String,
         message: String,
         defaultErrorType: DefaultErrorType) {
        self.code = code
        self.title = title
        self.message = message
        self.defaultErrorType = defaultErrorType
    }
    
    static func getDefaultError(type: DefaultErrorType) -> ErrorModel {
        return ErrorModel(code: type.getCode(), title: type.getTitle(), message: type.getMessage(), defaultErrorType: type)
    }
    
    func getFormattedMessage() -> String {
        return "Network.message.error".localizedFill(message, code)
    }
}
