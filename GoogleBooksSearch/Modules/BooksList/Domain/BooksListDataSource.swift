//
//  BooksListDataSource.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 27.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BooksListDataSourceProtocol {
    
    //parse data received from Books Google API
    func parseSearchBooksResponse(fromData data: Data?) throws -> Array<BookEntity>
}

public class BooksListDataSource: BooksListDataSourceProtocol {
    
    //parse data received from Books Google API
    public func parseSearchBooksResponse(fromData data: Data?) throws -> Array<BookEntity> {
        
        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON {
            
            if let booksItems = json[BooksListDataSourceConstants.kItemsFieldKey] as? Array<JSON> {
                //return the non null BookEntity entities from received json
                return booksItems.flatMap(BookEntity.init)
            }
            else if let errorItem = json[BooksListDataSourceConstants.kErrorFieldKey] as? JSON {
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

fileprivate struct BooksListDataSourceConstants {
    static let kItemsFieldKey = "items"
    static let kErrorFieldKey = "error"
}
