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

public protocol BooksListRepositoryProtocol {

    var dataSource: BooksListDataSourceProtocol? { get set }
    var imagesManager: BookImagesManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }

    func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? )
    func getImageBook(uriImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BooksListRepository: BooksListRepositoryProtocol {
    
    public var networkingManager: NetworkingManagerProtocol?
    public var imagesManager: BookImagesManagerProtocol?
    public var dataSource: BooksListDataSourceProtocol?
    
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
        
        imagesManager?.getImageBook(uriImage: uriImage, onSuccess: onSuccess, onFailure: onFailure)
    }
}

fileprivate struct BooksListRepositoryConstants {
    static let volumesResource: String = "volumes"
}
