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
typealias OnFailureResponseType = (Error?) -> (Void)

private let kItemsFieldKey = "items"
private let kErrorFieldKey = "error"


class BooksListInteractor {
    
    
    private let booksQueryBaseURL: String = "https://www.googleapis.com/books/v1/volumes"
    
    //parse data received from Books Google API
    private func parseSearchBooksResponse( data: Data?) throws -> Array<BookEntity> {
        
        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON {
            
            if let booksItems = json[kItemsFieldKey] as? Array<JSON> {
                //return the non null BookEntity entities from received json
                return booksItems.flatMap(BookEntity.init)
            }
            else if let errorItem = json[kErrorFieldKey] as? JSON {
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
    
    //get data books with Goggle API
    public func searchBooks(filter: String, onSuccess: OnSuccessResponseType?, onFailure: OnFailureResponseType? ) {
        
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
    
    //download image from a string url
    public func downloadImageBook(urlImage: String, onSuccess: OnSuccessDataResponseType?, onFailure: OnFailureResponseType?) {
        if let url = URL(string: urlImage) {
            self.getDataFromUrl(url: url, completion: { (dataImage, urlResponse, error) in
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
    
    //common function for getting data
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        print("Get data from: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
