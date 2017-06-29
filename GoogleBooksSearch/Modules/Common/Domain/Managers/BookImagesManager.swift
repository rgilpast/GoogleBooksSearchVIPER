//
//  BookImagesManager.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnImageDataBookResponseType = (Data?) -> (Void)

public protocol BookImagesManagerProtocol {

    static var sharedInstance: BookImagesManagerProtocol { get }
    var imageCacheManager: DataCacheManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }
    
    func getImageBook(uriImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BookImagesManager: BookImagesManagerProtocol {
    
    public static var sharedInstance: BookImagesManagerProtocol = BookImagesManager()
    
    public var imageCacheManager: DataCacheManagerProtocol?
    public var networkingManager: NetworkingManagerProtocol?
    
    fileprivate init() {}
    
    //get image from its uri
    public func getImageBook(uriImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?) {
        
        // check if the image´s book is cached
        if let imageData = imageCacheManager?.getDataItem(withKey: uriImage) {
            onSuccess?(imageData)
        }
        else {
            //download image from received uri
            downloadImageBook(urlImage: uriImage, onSuccess: onSuccess, onFailure: onFailure)
        }
    }
}

fileprivate extension BookImagesManager {
    
    //download image from a string url
    func downloadImageBook(urlImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?) {
        if let url = URL(string: urlImage) {
            networkingManager?.getDataFromUrl(url: url, completion: { [weak self] (dataImage, urlResponse, error) in
                if error != nil
                {
                    onFailure?(error)
                }
                else {
                    //caching the image
                    if let image = dataImage {
                        self?.imageCacheManager?.setDataItem(dataItem: image, withKey: urlImage)
                    }
                    onSuccess?(dataImage)
                }
            })
        }
    }
}
