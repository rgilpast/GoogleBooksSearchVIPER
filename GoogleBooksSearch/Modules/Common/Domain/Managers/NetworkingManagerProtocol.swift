//
//  NetworkingManager.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 19/6/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//


import Foundation

public protocol NetworkingManagerProtocol {

    static func createManager(forBaseURL url: URL) -> NetworkingManagerProtocol
    func getDataFromResource(resource: String, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    
}
