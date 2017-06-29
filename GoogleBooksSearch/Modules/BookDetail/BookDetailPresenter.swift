//
//  BookDetailPresenter.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BookDetailPresenterProtocol {
    
}

public class BookDetailPresenter: BookDetailPresenterProtocol {
    
    fileprivate weak var ui:BookDetailUIProtocol?
    public var interactor: BookDetailInteractorProtocol?
    
    public init(withUI: BookDetailUIProtocol?)
    {
        //store the reference of ui
        ui = withUI
    }
}
