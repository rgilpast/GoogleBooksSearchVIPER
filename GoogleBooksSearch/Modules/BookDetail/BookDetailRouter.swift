//
//  BookDetailRouter.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public typealias BookDetailExitResult = Any

public struct BookDetailRouterInfo {
    var bookId: String
}

public protocol BookDetailRouterProtocol: class, RouterProtocol {
    
    func back()
}

public protocol BookDetailOutputProtocol: RouterOutputProtocol {
    
    func exit(result: BookDetailExitResult?)
}

public class BookDetailRouter: BookDetailRouterProtocol {
    
    fileprivate weak var outputHandler: BookDetailOutputProtocol?
    fileprivate var networkingManager: NetworkingManagerProtocol? = {
        
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:BookDetailRouterConstants.baseURL) {
            manager = URLSessionManager.sharedInstance(forBaseURL: urlBase)
        }
        return manager
    }()
    
    public var mainView: UIViewController?
    
    public func create(withInfo info: Any?, output: RouterOutputProtocol?) -> UIViewController? {
        
        mainView = BookDetailRouter.createInstanceFromStoryboard()
        guard let info = info as? BookDetailRouterInfo, let ui = mainView as? BookDetailUIProtocol else {
            return nil
        }
        
        createDependencies(forUI: ui, output: output as? BookDetailOutputProtocol, bookId: info.bookId)
        
        return mainView
    }
    
    public func back() {
        mainView?.dismiss(animated: true, completion: { [weak self] in
            self?.outputHandler?.exit(result: nil)
        })
    }
}

fileprivate extension BookDetailRouter {
    
    class func createInstanceFromStoryboard() -> UIViewController? {
        
        guard let view = BookDetailRouter.createViewInstance(witViewId: BookDetailRouterConstants.bookDetailViewId, fromStoryboard: BookDetailRouterConstants.bookDetailSoryboardId) else {
            return nil
        }
        return view
    }
    
    func createDependencies(forUI ui: BookDetailUIProtocol, output: BookDetailOutputProtocol?, bookId: String) {
        
        let presenter = BookDetailPresenter(withUI: ui, router: self)
        let interactor = BookDetailInteractor()
        let repository = BookDetailRepository()
        var imagesManager = BookImagesManager.sharedInstance
        let imageCacheManager = DataMemoryCacheManager.sharedInstance
        let datasource = BookDetailDataSource(withBookId: bookId)
        
        imagesManager.imageCacheManager = imageCacheManager
        imagesManager.networkingManager = networkingManager
        repository.dataSource = datasource
        repository.imagesManager = imagesManager
        repository.networkingManager = networkingManager
        interactor.repository = repository
        presenter.interactor = interactor
        ui.presenter = presenter
        
        outputHandler = output
    }
}

fileprivate struct BookDetailRouterConstants {
    
    static let bookDetailViewId = "BookDetailViewController"
    static let bookDetailSoryboardId = "Main"
    static let baseURL: String = "https://www.googleapis.com/books/v1"
}
