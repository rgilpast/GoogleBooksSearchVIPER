//
//  BooksListRouter.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class BooksListRouter: RouterProtocol {

    fileprivate static var networkingManager: NetworkingManagerProtocol? = {
        
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BooksListRouterConstants.baseURL) {
            manager = URLSessionManager.createManager(forBaseURL: urlBase)
        }
        return manager
    }()
    
    public static func create(withInfo info: Any?) -> UIViewController? {
        
        guard let view = createInstanceFromStoryboard() else {
            return nil
        }
        
        if let ui = view as? BooksListsUIProtocol {
            createDependencies(forUI: ui)
        }
        
        let navigationView = UINavigationController(rootViewController: view)
        return navigationView
    }
}

fileprivate extension BooksListRouter {
    
    class func createInstanceFromStoryboard() -> UIViewController? {
        
        guard let view = createViewInstance(witViewId: BooksListRouterConstants.booksListViewId, fromStoryboard: BooksListRouterConstants.booksListSoryboardId) else {
            return nil
        }
        return view
    }
    
    class func createDependencies(forUI ui: BooksListsUIProtocol) {
        
        let presenter = BooksListPresenter(withUI: ui)
        let interactor = BooksListInteractor()
        let repository = BooksListRepository()
        let imageCacheManager = DataMemoryCacheManager.sharedInstance
        let dataSource = BooksListDataSource()

        repository.dataSource = dataSource
        repository.imageCacheManager = imageCacheManager
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
