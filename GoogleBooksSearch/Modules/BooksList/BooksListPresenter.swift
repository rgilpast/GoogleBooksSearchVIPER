//
//  BooksListPresenter.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnCompletionImageDownloadType = (Data?) -> (Void)

public protocol BooksListPresenterProtocol: class
{
    func viewDidLoad()
    func askForBooks(filter: String)
    func askForBookImage(book: BookViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    func didSelectBook(book: BookViewEntity)
}

public class BooksListPresenter: BooksListPresenterProtocol {

    public weak var ui:BooksListsUIProtocol?
    
    public lazy var interactor: BooksListInteractor = {
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
        self.interactor.getImageBook(uriImage: book?.urlBookImage, onSuccess: { (imageData) -> (Void) in
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
        
        //TODO: fetch detail book from interactor
        
    }
}
