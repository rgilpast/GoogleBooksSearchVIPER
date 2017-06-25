//
//  BooksListPresenter.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

typealias OnCompletionImageDownloadType = (Data?) -> (Void)

protocol BooksListPresenterProtocol: class
{
    func viewDidLoad()
    func askForBooks(filter: String)
    func askForBookImage(bookImageURL: String, onCompletion:OnCompletionImageDownloadType?)
    func didSelectBook(bookIndex: Int)
}

class BooksListPresenter: BooksListPresenterProtocol {

    private weak var ui:BooksListsUIProtocol?
    
    private lazy var interactor: BooksListInteractor = {
        return BooksListInteractor()
    }()
    
    public init(withUI: BooksListsUIProtocol?)
    {
        //store the reference of ui
        self.ui = withUI
    }

    public func viewDidLoad() {
        
        //by default ask for all books
        askForBooks(filter: "")
        
    }

    //ask for books matches the criteria received in filter parameter
    public func askForBooks(filter: String) {
        
        self.ui?.showLoadingIndicator()
        
        self.interactor.searchBooks(filter: filter, onSuccess: {[weak self] (books) -> (Void) in

            DispatchQueue.main.async {
                
                self?.ui?.hideLoadingIndicator()
                
                //map received books in a specific view model entities array and pass them to the ui for displaying
                let viewBooks = books.map({ (bookEntity) -> BookViewEntity in
                    return BookViewEntity(title: bookEntity.title, authors: bookEntity.authors.joined(separator: ", "), urlBookImage: bookEntity.imageURL)
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
    public func askForBookImage(bookImageURL: String, onCompletion:OnCompletionImageDownloadType?)
    {
        self.interactor.downloadImageBook(urlImage: bookImageURL, onSuccess: { (imageData) -> (Void) in
            DispatchQueue.main.async {
                onCompletion?(imageData)
            }
    
        }) { (error) -> (Void) in
            DispatchQueue.main.async {
                onCompletion?(nil)
            }
        }
    }

    public func didSelectBook(bookIndex: Int) {
        
        //TODO: fetch detail book with received index from interactor
        
    }
}
