//
//  BookDetailEntity.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 30.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public struct BookDetailEntity {
    
    //private fields´ keys
    private let kIdFieldKey = "id"
    private let kVolumeInfoFieldKey = "volumeInfo"
    private let kTitleFieldKey = "title"
    private let kSubtitleFieldKey = "subtitle"
    private let kAuthorsFieldKey = "authors"
    private let kImageLinksFieldKey = "imageLinks"
    private let kSmallImageFieldKey = "small"
    private let kCategoriesFieldKey = "categories"
    private let kPageCountFieldKey = "pageCount"
    private let kPublisherFieldKey = "publisher"
    private let kPublishedDateFieldKey = "publishedDate"
    private let kDescriptionFieldKey = "publishedDate"
    
    //public properties
    public var title: String
    public var subtitle: String?
    public var authors: Array<String>
    public var id: String
    public var imageURL: String?
    public var categories: Array<String>?
    public var pageCount: Int?
    public var publisher: String?
    public var publishedDate: Date?
    public var sinopsis: String?
    
    public init?(json: JSON)
    {
        //check the existence of required data
        guard   let volumeInfo = json[kVolumeInfoFieldKey] as? JSON,
            let title = volumeInfo[kTitleFieldKey] as? String,
            let authors = volumeInfo[kAuthorsFieldKey] as? Array<String>,
            let id = json[kIdFieldKey] as? String
            else {
                return nil
        }
        self.title = title
        self.authors = authors
        self.id = id
        
        //optional data
        self.imageURL = volumeInfo[kImageLinksFieldKey]?[kSmallImageFieldKey] as? String
        self.subtitle = volumeInfo[kSubtitleFieldKey] as? String
        self.categories = volumeInfo[kCategoriesFieldKey] as? Array<String>
        self.pageCount = volumeInfo[kPageCountFieldKey] as? Int
        self.publisher = volumeInfo[kPublisherFieldKey] as? String
        self.publishedDate = volumeInfo[kPublishedDateFieldKey] as? Date
        self.sinopsis = volumeInfo[kDescriptionFieldKey] as? String
    }
}
