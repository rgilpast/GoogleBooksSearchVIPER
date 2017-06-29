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
}

public class BookDetailInteractor: BookDetailInteractorProtocol {
    
    public var repository: BookDetailRepositoryProtocol?
}
