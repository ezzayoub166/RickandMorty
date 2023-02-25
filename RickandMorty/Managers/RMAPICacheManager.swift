//
//  RMAPICacheManager.swift
//  RickandMorty
//
//  Created by ezz on 13/02/2023.
//

import Foundation

final class RMAPICacheManager {
    
    public var cacheDictionary : [RMEndpoint : NSCache<NSString , NSData>] = [:]
    
    public var cache = NSCache<NSString , NSData>()
    
    //MARK: - Init
    
    init(){
        setUpCache()
    }
    
    
    //MARK: Public
    
    public func cacheResponse(for endpoint : RMEndpoint , url : URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint] , let url = url else {
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint : RMEndpoint , url : URL? , data : Data) {
        guard let targetCache = cacheDictionary[endpoint] , let url = url else {
            return 
        }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    //MARK: Private
    private func setUpCache(){
        RMEndpoint.allCases.forEach({ enpoint in
            cacheDictionary[enpoint] = NSCache<NSString , NSData>()
            
        })
    }
    
    
}
