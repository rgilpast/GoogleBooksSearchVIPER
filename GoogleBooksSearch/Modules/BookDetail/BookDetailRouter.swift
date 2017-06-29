//
//  BookDetailRouter.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class BookDetailRouter: RouterProtocol {
    
    fileprivate static var networkingManager: NetworkingManagerProtocol? = {
        
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BookDetailRouterConstants.baseURL) {
            manager = URLSessionManager.sharedInstance(forBaseURL: urlBase)
        }
        return manager
    }()

    public static func create(withInfo info: Any?) -> UIViewController? {
        
        guard let view = createInstanceFromStoryboard() else {
            return nil
        }
        
        if let ui = view as? BookDetailUIProtocol {
            createDependencies(forUI: ui)
        }
        
        let navigationView = UINavigationController(rootViewController: view)
        return navigationView
    }
}

fileprivate extension BookDetailRouter {
    
    class func createInstanceFromStoryboard() -> UIViewController? {
        
        guard let view = createViewInstance(witViewId: BookDetailRouterConstants.bookDetailViewId, fromStoryboard: BookDetailRouterConstants.bookDetailSoryboardId) else {
            return nil
        }
        return view
    }
    
    class func createDependencies(forUI ui: BookDetailUIProtocol) {
        
        let presenter = BookDetailPresenter(withUI: ui)
        let interactor = BookDetailInteractor()
        let repository = BookDetailRepository()
        let imageCacheManager = DataMemoryCacheManager.sharedInstance
        
        repository.imageCacheManager = imageCacheManager
        repository.networkingManager = networkingManager
        interactor.repository = repository
        presenter.interactor = interactor
        ui.presenter = presenter
    }
}

fileprivate struct BookDetailRouterConstants {
    
    static let bookDetailViewId = "BookDetailViewController"
    static let bookDetailSoryboardId = "Main"
    static let baseURL: String = "https://www.googleapis.com/books/v1"
}
