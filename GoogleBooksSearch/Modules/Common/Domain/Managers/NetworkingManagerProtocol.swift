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
    static func sharedInstance(forBaseURL url: URL) -> NetworkingManagerProtocol
    static func removeInstance(forBaseURL url: URL)
    static func removeAllInstances()

    func getDataFromResource(resource: String, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
    
}
