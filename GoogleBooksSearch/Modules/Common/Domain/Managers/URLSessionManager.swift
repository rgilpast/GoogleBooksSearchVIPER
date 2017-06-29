//
//  URLSessionManager.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 19/6/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public class URLSessionManager: NetworkingManagerProtocol {
    
    fileprivate var baseURL: URL
    fileprivate static var managers: [String : NetworkingManagerProtocol] = [ : ]
    
    fileprivate init(withBaseURL url: URL) {
        baseURL = url
    }

    public static func sharedInstance(forBaseURL url: URL) -> NetworkingManagerProtocol {
        
        let urlString = url.absoluteString
        guard let manager = managers[urlString] else {
            let newManager = createManager(forBaseURL: url)
            managers[urlString] = newManager
            return newManager
        }
        return manager
    }
    
    public static func createManager(forBaseURL url: URL) -> NetworkingManagerProtocol {
        
        let manager = URLSessionManager(withBaseURL: url)
        return manager
    }
    
    public static func removeInstance(forBaseURL url: URL) {
        
        managers.removeValue(forKey: url.absoluteString)
    }
    
    public static func removeAllInstances() {
        
        managers.removeAll()
    }
    
    public func getDataFromResource(resource: String, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        if let urlRequest: URL = URL(string: baseURL.absoluteString + "/\(resource)") {
            
            getDataFromUrl(url: urlRequest, completion: completion)
        }
    }
    
    public func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        print("Get data from: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
