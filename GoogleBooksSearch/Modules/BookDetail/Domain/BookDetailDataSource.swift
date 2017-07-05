//
//  BookDetailDataSource.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 03.07.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BookDetailDataSourceProtocol {
    
    var bookId: String { get set }
    //parse data received from Books Google API
    func parseBookDetailResponse(fromData data: Data?) throws -> BookDetailEntity
}

public class BookDetailDataSource: BookDetailDataSourceProtocol {
    
    public var bookId: String = ""
    
    public init(withBookId bookId: String) {
        self.bookId = bookId
    }
    
    //parse data received from Books Google API
    public func parseBookDetailResponse(fromData data: Data?) throws -> BookDetailEntity {
        
        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON {
            
            if let detail = BookDetailEntity(json: json) {
                //return the non null BookDetailEntity entity from received json
                return detail
            }
            else {
                //not data received or malformed data
                throw ServerError.malformedDataError()
            }
        }
        else {
            //not data received or malformed data
            throw ServerError.malformedDataError()
        }
    }
}
