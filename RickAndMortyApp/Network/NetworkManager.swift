//
//  NetworkManager.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import UIKit

enum RequestMethod: String {
    case get = "GET"
}

class NetworkManager {
    func request<responseType: Decodable>(url: String,
                                          method: RequestMethod,
                                          responseType: responseType.Type,
                                          success: @escaping (_ modelResponse: responseType) -> Void,
                                          failure: @escaping (_ errorResponse: ErrorModel) -> Void) {
        request(url: url, method: method) { responseData in
            guard let decodedResponse = try? JSONDecoder().decode(responseType.self, from: responseData) else {
                failure(ErrorModel.getDefaultError(type: .badResponseBody))
                return
            }
            success(decodedResponse)
        } failure: { errorResponse in
            failure(errorResponse)
        }
    }
    
    func request(url: String,
                 method: RequestMethod,
                 success: @escaping (_ responseData: Data) -> Void,
                 failure: @escaping (_ errorResponse: ErrorModel) -> Void) {
        guard let notNilURL = URL(string: url) else {
            failure(ErrorModel.getDefaultError(type: .badURL))
            return
        }
        
        var request = URLRequest(url: notNilURL)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { responseData, responseURL, error in
            guard let notNilResponseData = responseData, let httpErrorResponse = responseURL as? HTTPURLResponse else {
                guard let nsError = error as? NSError else {
                    failure(ErrorModel.getDefaultError(type: .unknown))
                    return
                }
                
                guard let urlError = nsError as? URLError, urlError.code == URLError.Code.notConnectedToInternet else {
                    failure(ErrorModel(code: "\(nsError.code)", message: nsError.localizedDescription))
                    return
                }
                
                failure(ErrorModel.getDefaultError(type: .noInternet))
                return
            }
            
            let statusCode = httpErrorResponse.statusCode
            
            guard (200...299) ~= statusCode else {
                failure(ErrorModel(code: "\(statusCode)", message: HTTPURLResponse.localizedString(forStatusCode: statusCode)))
                return
            }
            success(notNilResponseData)
        }.resume()
    }
    
    
    func fetchImage(url: String, 
                    success: @escaping (_ responseData: UIImage) -> Void,
                    failure: @escaping (_ errorResponse: ErrorModel) -> Void) {
        guard let notNilURL = URL(string: url) else {
            failure(ErrorModel.getDefaultError(type: .badURL))
            return
        }
        
        let request = URLRequest(url: notNilURL)
        
        URLSession.shared.dataTask(with: request) { responseData, responseURL, error in
            guard let notNilResponseData = responseData, let httpErrorResponse = responseURL as? HTTPURLResponse else {
                guard let nsError = error as? NSError else {
                    failure(ErrorModel.getDefaultError(type: .unknown))
                    return
                }
                
                guard let urlError = nsError as? URLError, urlError.code == URLError.Code.notConnectedToInternet else {
                    failure(ErrorModel(code: "\(nsError.code)", message: nsError.localizedDescription))
                    return
                }
                
                failure(ErrorModel.getDefaultError(type: .noInternet))
                return
            }
            
            let statusCode = httpErrorResponse.statusCode
            
            guard (200...299) ~= statusCode else {
                failure(ErrorModel(code: "\(statusCode)", message: HTTPURLResponse.localizedString(forStatusCode: statusCode)))
                return
            }
            guard let image = UIImage(data: notNilResponseData) else {
                return
            }
            success(image)
        }.resume()
    }
}
