//
//  BookDetailRepository.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BookDetailRepositoryProtocol {
    
    var imageCacheManager: DataCacheManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }
}

public class BookDetailRepository: BookDetailRepositoryProtocol{
    
    public var imageCacheManager: DataCacheManagerProtocol?
    public var networkingManager: NetworkingManagerProtocol?
}
