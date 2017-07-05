//
//  BookDetailRepository.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnBookDetailResponseType = (BookDetailEntity) -> (Void)

public protocol BookDetailRepositoryProtocol {
    
    var imagesManager: BookImagesManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }
    var dataSource: BookDetailDataSourceProtocol? { get set }
    
    func getBookDetail(onSuccess: OnBookDetailResponseType?, onFailure: OnFailureResponseType?)
    func getImageBook(uriImage: String, onSuccess: OnImageDataBookResponseType?, onFailure: OnFailureResponseType?)
}

public class BookDetailRepository: BookDetailRepositoryProtocol{
    
    public var networkingManager: NetworkingManagerProtocol?
    public var imagesManager: BookImagesManagerProtocol?
    public var dataSource: BookDetailDataSourceProtocol?
    
    public func getBookDetail(onSuccess: OnBookDetailResponseType?, onFailure: OnFailureResponseType?) {
        
        let query = "\(BookDetailRepositoryConstants.volumesResource)/\(dataSource?.bookId ?? "")"
        //ask for books through Google API
        networkingManager?.getDataFromResource(resource: query, completion: { [weak self] (booksData, urlResponse, error) in
            
            do {
                guard error == nil, let bookDetail = try self?.dataSource?.parseBookDetailResponse(fromData: booksData) else {
                    //we haven´t got the books from data
                    onFailure?( error != nil ? error! as NSError : ServerError.noDataError())
                    return
                }
                //return the received books as BookEntity objects array
                onSuccess?(bookDetail)
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

fileprivate struct BookDetailRepositoryConstants {
    static let volumesResource: String = "volumes"
}

