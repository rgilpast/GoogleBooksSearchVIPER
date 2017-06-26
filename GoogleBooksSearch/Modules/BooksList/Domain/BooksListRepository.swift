//
//  BookListRepository.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 19/6/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnBooksListResponseType = (Array<BookEntity>) -> (Void)
public typealias OnImageDataBookResponseType = (Data?) -> (Void)

public protocol BooksListRepositoryProtocol {

    func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? )
    func downloadImageBook(urlImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BooksListRepository: BooksListRepositoryProtocol {
    
    public lazy var networkingManager: NetworkingManagerProtocol? = {
       
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BooksListRepositoryConstants.baseURL) {
            manager = URLSessionManager.createManager(forBaseURL: urlBase)
        }
        return manager
    }()
    
    //get data books with Goggle API
    public func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? ) {
        
        let searchQuery = "\(BooksListRepositoryConstants.volumesResource)?q='\(filter)'"
        //ask for books through Google API
        networkingManager?.getDataFromResource(resource: searchQuery, completion: { [weak self] (booksData, urlResponse, error) in
            if error != nil
            {
                onFailure?(error)
            }
            else {
                
                do {
                    if let books = try self?.parseSearchBooksResponse(data: booksData) {
                        //return the received books as BookEntity objects array
                        onSuccess?(books)
                    }
                    else {
                        //we haven´t got the books from data
                        onFailure?(ServerError.noDataError())
                    }
                } catch let jsonError {
                    //throws the error catched from parsing
                    onFailure?(jsonError)
                }
            }
        })
    }
    
    //download image from a string url
    public func downloadImageBook(urlImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?) {
        if let url = URL(string: urlImage) {
            networkingManager?.getDataFromUrl(url: url, completion: { (dataImage, urlResponse, error) in
                if error != nil
                {
                    onFailure?(error)
                }
                else {
                    onSuccess?(dataImage)
                }
            })
        }
    }
}

fileprivate extension BooksListRepository {
    //parse data received from Books Google API
    func parseSearchBooksResponse( data: Data?) throws -> Array<BookEntity> {
        
        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON {
            
            if let booksItems = json[BooksListRepositoryConstants.kItemsFieldKey] as? Array<JSON> {
                //return the non null BookEntity entities from received json
                return booksItems.flatMap(BookEntity.init)
            }
            else if let errorItem = json[BooksListRepositoryConstants.kErrorFieldKey] as? JSON {
                //throw error received from Google or an undefined error
                throw ServerError(json: errorItem)?.toNSError() ?? ServerError.undefinedError()
            }
            else {
                //unexpected data received
                throw ServerError.unexpectedDataError()
            }
        }
        else {
            //not data received or malformed data
            throw ServerError.malformedDataError()
        }
    }
}

fileprivate struct BooksListRepositoryConstants {
    static let baseURL: String = "https://www.googleapis.com/books/v1"
    static let volumesResource: String = "volumes"
    static let kItemsFieldKey = "items"
    static let kErrorFieldKey = "error"
}
