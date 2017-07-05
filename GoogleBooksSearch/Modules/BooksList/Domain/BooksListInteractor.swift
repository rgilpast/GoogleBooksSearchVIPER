//
//  BooksListInteractor.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BooksListInteractorProtocol {
    
    var repository: BooksListRepositoryProtocol? { get set }
    
    func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? )
    func getImageBook(uriImage: String?, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BooksListInteractor: BooksListInteractorProtocol {
    
    public var repository: BooksListRepositoryProtocol?
    
    //get data books from repository
    public func searchBooks(filter: String, onSuccess: OnBooksListResponseType?, onFailure: OnFailureResponseType? ) {
        
        repository?.searchBooks(filter: filter, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    //get the image´s  book from a its url
    public func getImageBook(uriImage: String?, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?) {
        
        guard let uri = uriImage  else {
            onSuccess?(nil)
            return
        }
        repository?.getImageBook(uriImage: uri, onSuccess: onSuccess, onFailure: onFailure)
    }
}
