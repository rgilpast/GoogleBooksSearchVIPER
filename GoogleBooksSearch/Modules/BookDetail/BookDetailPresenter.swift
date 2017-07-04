//
//  BookDetailPresenter.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol BookDetailPresenterProtocol {

    var interactor: BookDetailInteractorProtocol? { get set }
    
    init(withUI: BookDetailUIProtocol?, router: BookDetailRouterProtocol?)
    func viewDidLoad()
    func askForBookImage(book: BookDetailViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    func back()
}

public class BookDetailPresenter: BookDetailPresenterProtocol {
    
    fileprivate weak var ui: BookDetailUIProtocol?
    fileprivate weak var router: BookDetailRouterProtocol?
    
    public var interactor: BookDetailInteractorProtocol?
    
    public required init(withUI: BookDetailUIProtocol?, router: BookDetailRouterProtocol?)
    {
        ui = withUI
        self.router = router
    }
    
    public func viewDidLoad() {
        
        askBookDetail()
    }
}

public extension BookDetailPresenter {
    
    //ask for book detail whose id is passed in
    func askBookDetail() {
        
        ui?.showLoadingIndicator()
        
        interactor?.getBookDetail(onSuccess: { [weak self] (detail) -> (Void) in
            
            let publishInfo = self?.buildPublishInfo(publisher: detail.publisher, publishDate: detail.publishedDate)
            let categoryAndPageCountInfo = self?.buildCategoryAndPageCountInfo(categories: detail.categories, pageCount: detail.pageCount)
            
            let bookDetail = BookDetailViewEntity( urlBookImage: detail.imageURL,
                                                   title: detail.title,
                                                   subtitle: detail.subtitle,
                                                   authors: detail.authors.joined(separator: ", "),
                                                   publishInfo: publishInfo,
                                                   categoryAndPageCount: categoryAndPageCountInfo,
                                                   sinopsis: detail.sinopsis)
            DispatchQueue.main.async {
                
                self?.ui?.hideLoadingIndicator()
                self?.ui?.showBookDetail(detail: bookDetail)
            }
            
        }, onFailure: { [weak self] (error) -> (Void) in
            
            DispatchQueue.main.async {
                
                self?.ui?.showMessageError(error: error, completion: {
                    self?.ui?.hideLoadingIndicator()
                })
            }
        })
    }
    
    func askForBookImage(book: BookDetailViewEntity?, onCompletion: OnCompletionImageDownloadType?) {
        
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
    
    func back() {
        router?.back()
    }
}

private extension BookDetailPresenter {
    
    func buildPublishInfo(publisher: String?, publishDate: Date?) -> String {
        
        let publisherString = publisher ?? ""
        
        var publishedDateString: String = ""
        if let date = publishDate {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            publishedDateString = formatter.string(from: date)
        }
        let publishInfo: String = publisherString + ((!publisherString.isEmpty && !publishedDateString.isEmpty) ? " - \(publishedDateString)" : publishedDateString)
        
        return publishInfo
    }
    
    func buildCategoryAndPageCountInfo(categories: Array<String>?, pageCount: Int?) -> String {
        
        let categoriesString = categories?.joined(separator: ", ") ?? ""
        
        var pageCountString: String = ""
        if let pageCount = pageCount {
            
            pageCountString = "\(String(pageCount)) \(NSLocalizedString("GBS_DETAIL_PAGES", comment: ""))"
        }
        let categoryAndPageCountString: String = pageCountString + ((!categoriesString.isEmpty && !pageCountString.isEmpty) ? " - \(categoriesString)" : categoriesString)
        
        return categoryAndPageCountString
    }
}
