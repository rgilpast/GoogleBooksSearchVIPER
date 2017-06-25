//
//  BookListRepository.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 19/6/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnBooksListResponseType = (Array<BookEntity>) -> (Void)
public typealias OnFailureResponseType = (Error?) -> (Void)

public protocol BooksListRepositoryProtocol {

    func searchBooks(filter: String, onSuccess: OnSuccessResponseType?, onFailure: OnFailureResponseType? )
}

public class BooksListRepository: BooksListRepositoryProtocol {
    
    public lazy var networkingManager: NetworkingManagerProtocol? = {
       
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BooksListRepositoryConstants.baseURL) {
            manager = URLSessionManager.createManager(forBaseURL: urlBase)
        }
        return manager
    }()
}

//get data books with Goggle API
public func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? ) {
    
    let searchQuery = "\(booksQueryBaseURL)?q='\(filter)'"
    if let url = URL(string: searchQuery)
    {
        //ask for books through Google API
        self.getDataFromUrl(url: url, completion: { [weak self] (booksData, urlResponse, error) in
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
    else {
        //malformed URL service
        onFailure?(ServerError.internalError())
    }
}

fileprivate struct BooksListRepositoryConstants {
    static let baseURL: String = "https://www.googleapis.com/books/v1"
    static let volumesResource: String = "volumes"
}
