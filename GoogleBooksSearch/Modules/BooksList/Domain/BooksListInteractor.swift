//
//  BooksListInteractor.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

typealias OnSuccessResponseType = (Array<BookEntity>) -> (Void)
typealias OnSuccessDataResponseType = (Data?) -> (Void)

public protocol BooksListInteractorProtocol {
    
    var repository: BooksListRepositoryProtocol? { get set }
    func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? )
}

public class BooksListInteractor: BooksListInteractorProtocol {
    
    public var repository: BooksListRepositoryProtocol? = BooksListRepository()
    
    //get data books from repository
    public func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? ) {
        
        repository?.searchBooks(filter: filter, onSuccess: onSuccess, onFailure: onFailure)
    }
    
}
