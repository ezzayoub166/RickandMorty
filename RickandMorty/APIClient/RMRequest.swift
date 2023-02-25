//
//  RMRequest.swift
//  RickandMorty
//
//  Created by ezz on 03/02/2023.
//

import Foundation

final class RMRequest {
    
    public struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    let endpoint : RMEndpoint
    
    private let pathComponents : [String]
    
    private let queryParamters : [URLQueryItem]
    
    ///Constructed url for api Request in string Format
    private var urlString : String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({string += "/\($0)"})
        }
        
        if !queryParamters.isEmpty {
            string += "?"
            let argumentString = queryParamters.compactMap({
                
                guard let value = $0.value else {return nil}  // "2"
                return "\($0.name)=\(value)" //"page=2"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    public var url : URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    public init(endpoint: RMEndpoint ,
         pathComponents:[String] = [] ,
         queryParmters : [URLQueryItem] = []
    ){
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParamters = queryParmters
    }
    //Base url
    //EndPoint
    // Additonal path
    //Query Parmater
    ///https://rickandmortyapi.com/api/character/2
    
    convenience init?(url : URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty{
                let endpointString = components[0]
                var pathComponents : [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint , pathComponents : pathComponents)
                    return
                }
            }
        }
        else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty , components.count >= 2{
                let endpointString = components[0]
                let queryItemString = components[1]
                //value=name&value&name
                let queryItems : [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0],
                                        value: parts[1])
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint , queryParmters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listEpisodesRequests = RMRequest(endpoint: .episode)
    static let listLocationRequests = RMRequest(endpoint: .location)

}
