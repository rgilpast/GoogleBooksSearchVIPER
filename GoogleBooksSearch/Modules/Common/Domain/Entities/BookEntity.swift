//
//  BookEntity.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation


public struct BookEntity
{
    //private fields´ keys
    private let kTitleFieldKey = "title"
    private let kAuthorsFieldKey = "authors"
    private let kImageLinksFieldKey = "imageLinks"
    private let kThumbnailFieldKey = "thumbnail"
    private let kVolumeInfoFieldKey = "volumeInfo"
    private let kIdFieldKey = "id"

    //public properties
    public var title: String
    public var authors: Array<String>
    public var id: String
    public var imageURL: String?
    
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
        self.imageURL = volumeInfo[kImageLinksFieldKey]?[kThumbnailFieldKey] as? String
    }
}
