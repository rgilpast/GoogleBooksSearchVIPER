//
//  BookDetailViewController.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import UIKit


public protocol BookDetailViewProtocol:class {
    
    var presenter: BookDetailPresenter? { get set }
    
    func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    func showDetail(forBook: BookDetailViewEntity)
}

public typealias BookDetailUIProtocol = BookDetailViewProtocol & AlertMessageProtocol

public struct BookDetailViewEntity
{
    let id: String!
    let title: String!
    let authors: String!
    let urlBookImage : String?
}

public class BookDetailViewController: UIViewController, BookDetailUIProtocol {

    public var presenter: BookDetailPresenter?

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func showDetail(forBook: BookDetailViewEntity) {
    }
}

//MARK : Message Error Management
extension BookDetailViewController {
    
    public func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    {
        showAlertMessage(fromView: self, error: error, completion: completion)
    }
}
