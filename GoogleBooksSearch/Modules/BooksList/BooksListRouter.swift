//
//  BooksListRouter.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol BooksListRouterProtocol: class, RouterProtocol {
    
    func showDetailBook(forBookId bookid: String, fromView: UIViewController, output: RouterOutputProtocol?)
}

public class BooksListRouter: BooksListRouterProtocol {


    public var mainView: UIViewController?
    public var detailRouter: RouterProtocol?
    
    fileprivate var networkingManager: NetworkingManagerProtocol? = {
        
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BooksListRouterConstants.baseURL) {
            manager = URLSessionManager.sharedInstance(forBaseURL: urlBase)
        }
        return manager
    }()
    
    public func create(withInfo info: Any?, output: RouterOutputProtocol?) -> UIViewController? {
        
        mainView = BooksListRouter.createInstanceFromStoryboard()
        guard let ui = mainView as? BooksListsUIProtocol else {
            return nil
        }
        
        createDependencies(forUI: ui)
        
        let navigationView = UINavigationController(rootViewController: mainView!)
        return navigationView
    }
    
    public func showDetailBook(forBookId bookid: String, fromView: UIViewController, output: RouterOutputProtocol?) {
        
        if let bookDetailView = detailRouter?.create(withInfo: BookDetailRouterInfo(bookId: bookid), output: output) {
            fromView.navigationController?.pushViewController(bookDetailView, animated: true)
        }
    }
}

fileprivate extension BooksListRouter {
    
    class func createInstanceFromStoryboard() -> UIViewController? {
        
        guard let view = createViewInstance(witViewId: BooksListRouterConstants.booksListViewId, fromStoryboard: BooksListRouterConstants.booksListSoryboardId) else {
            return nil
        }
        return view
    }
    
    func createDependencies(forUI ui: BooksListsUIProtocol) {
        
        detailRouter = BookDetailRouter()
        
        let presenter = BooksListPresenter(withUI: ui, router: self)
        let interactor = BooksListInteractor()
        let repository = BooksListRepository()
        var imagesManager = BookImagesManager.sharedInstance
        let imageCacheManager = DataMemoryCacheManager.sharedInstance
        let dataSource = BooksListDataSource()
        
        imagesManager.imageCacheManager = imageCacheManager
        imagesManager.networkingManager = networkingManager
        repository.dataSource = dataSource
        repository.imagesManager = imagesManager
        repository.networkingManager = networkingManager
        interactor.repository = repository
        presenter.interactor = interactor
        ui.presenter = presenter
    }
}

fileprivate struct BooksListRouterConstants {
    
    static let booksListViewId = "BooksListViewController"
    static let booksListSoryboardId = "Main"
    static let baseURL: String = "https://www.googleapis.com/books/v1"

}
