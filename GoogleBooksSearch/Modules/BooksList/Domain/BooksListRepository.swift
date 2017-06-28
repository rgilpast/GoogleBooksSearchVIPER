//
//  BookListRepository.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 19/6/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public typealias OnBooksListResponseType = (Array<BookEntity>) -> (Void)
public typealias OnImageDataBookResponseType = (Data?) -> (Void)

public protocol BooksListRepositoryProtocol {

    func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? )
    func getImageBook(uriImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BooksListRepository: BooksListRepositoryProtocol {
    
    fileprivate lazy var networkingManager: NetworkingManagerProtocol? = {
       
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BooksListRepositoryConstants.baseURL) {
            manager = URLSessionManager.createManager(forBaseURL: urlBase)
        }
        return manager
    }()
    
    public var imageCacheManager: DataCacheManagerProtocol? = DataMemoryCacheManager.sharedInstance
    public var dataSource: BooksListDataSourceProtocol? = BooksListDataSource()
    
    //get data books with Goggle API
    public func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? ) {
        
        let encodedFilter = filter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let searchQuery = "\(BooksListRepositoryConstants.volumesResource)?q='\(encodedFilter)'"
        //ask for books through Google API
        networkingManager?.getDataFromResource(resource: searchQuery, completion: { [weak self] (booksData, urlResponse, error) in
            
            do {
                guard error == nil, let books = try self?.dataSource?.parseSearchBooksResponse(fromData: booksData) else {
                    //we haven´t got the books from data
                    onFailure?( error != nil ? error! as NSError : ServerError.noDataError())
                    return
                }
                //return the received books as BookEntity objects array
                onSuccess?(books)
            } catch let jsonError {
                //throws the error catched from parsing
                onFailure?(jsonError)
            }
        })
    }
    
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

fileprivate extension BooksListRepository {

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

fileprivate struct BooksListRepositoryConstants {
    static let baseURL: String = "https://www.googleapis.com/books/v1"
    static let volumesResource: String = "volumes"
}
