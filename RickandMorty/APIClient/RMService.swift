//
//  RMService.swift
//  RickandMorty
//
//  Created by ezz on 03/02/2023.
//

import Foundation

/// Primary API service object to send Rick and Morty data
final class RMService {
    
    /// shared singletion instance
    static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    /// Privatized constructor
    private init(){}
    
    enum RMServiceError : Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    
    ///  Send Rick and Morty API Call
    /// - Parameters:
    ///   - _request:  Request instance
    ///   - completion: CallBack with data or error
    ///   - type : The Type of object we expect to back
    public func execute<T : Codable>
    (
        _ request : RMRequest ,
        expecting type : T.Type,
        completion : @escaping (Result<T,Error>) -> Void){
            
            
            if let cachedData = cacheManager.cacheResponse(for: request.endpoint,
                                                           url: request.url) {
                print("Using Cache API Response..")
                do{
                    let result = try JSONDecoder().decode(type.self, from: cachedData)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
                return
                
            }
            
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self]data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToGetData))
                    return
                }
                
                //Decode Response
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    self?.cacheManager.setCache(for: request.endpoint,
                                                url: request.url,
                                                data: data)
    
                    completion(.success(result))
                    
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
         
            
        }
    
    //MARK: - private
    
    private func request(from rmRequest : RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
