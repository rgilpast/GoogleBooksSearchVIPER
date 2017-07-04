//
//  BooksListPresenter.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public typealias OnCompletionImageDownloadType = (Data?) -> (Void)

public protocol BooksListPresenterProtocol: class
{
    var interactor: BooksListInteractorProtocol? { get set }
    weak var router: BooksListRouterProtocol? { get set }
    
    func viewDidLoad()
    func askForBooks(filter: String)
    func askForBookImage(book: BookViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    func didSelectBook(book: BookViewEntity)
}

public class BooksListPresenter: BooksListPresenterProtocol {
    
    fileprivate weak var ui:BooksListsUIProtocol?
    public weak var router: BooksListRouterProtocol?
    
    public var interactor: BooksListInteractorProtocol?
    
    public init(withUI: BooksListsUIProtocol?, router: BooksListRouterProtocol?)
    {
        //store the references of ui and router
        ui = withUI
        self.router = router
    }

    public func viewDidLoad() {
        
        //by default ask for all books
        askForBooks(filter: "")
    }

    //ask for books matches the criteria received in filter parameter
    public func askForBooks(filter: String) {
        
        ui?.showLoadingIndicator()
        
        interactor?.searchBooks(filter: filter, onSuccess: {[weak self] (books) -> (Void) in

            DispatchQueue.main.async {
                
                self?.ui?.hideLoadingIndicator()
                
                //map received books in a specific view model entities array and pass them to the ui for displaying
                let viewBooks = books.map({ (bookEntity) -> BookViewEntity in
                    return BookViewEntity(id: bookEntity.id, title: bookEntity.title, authors: bookEntity.authors.joined(separator: ", "), urlBookImage: bookEntity.imageURL)
                })
                self?.ui?.showBooks(books: viewBooks)
            }
            
        }) { [weak self] (error) -> (Void) in

            DispatchQueue.main.async {
                
                self?.ui?.showMessageError(error: error, completion: {
                    self?.ui?.hideLoadingIndicator()
                })
            }
        }
    }

    //ask for the related image of a book from its url
    public func askForBookImage(book: BookViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    {
        interactor?.getImageBook(uriImage: book?.urlBookImage, onSuccess: { (imageData) -> (Void) in
            DispatchQueue.main.async {
                onCompletion?(imageData)
            }
    
        }) { (error) -> (Void) in
            DispatchQueue.main.async {
                onCompletion?(nil)
            }
        }
    }

    public func didSelectBook(book: BookViewEntity) {
        
        if let view = ui as? UIViewController {
            router?.showDetailBook(forBookId: book.id, fromView: view, output: nil)
        }
    }
}
