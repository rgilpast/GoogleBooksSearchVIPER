//
//  BookDetailInteractor.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BookDetailInteractorProtocol {
    
    var repository: BookDetailRepositoryProtocol? { get set }

    func getBookDetail(onSuccess: OnBookDetailResponseType?, onFailure: OnFailureResponseType?)
    func getImageBook(uriImage: String?, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BookDetailInteractor: BookDetailInteractorProtocol {
    
    public var repository: BookDetailRepositoryProtocol?
}

public extension BookDetailInteractor {
    
    //get book detail from repository
    public func getBookDetail(onSuccess: OnBookDetailResponseType?, onFailure: OnFailureResponseType? ) {
        
        repository?.getBookDetail(onSuccess: onSuccess, onFailure: onFailure)
    }

    func getImageBook(uriImage: String?, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?) {
        
        guard let uri = uriImage  else {
            onSuccess?(nil)
            return
        }
        repository?.getImageBook(uriImage: uri, onSuccess: onSuccess, onFailure: onFailure)
    }
}
