//
//  ViewController.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import UIKit

public typealias ErrorMessageCompletion = () -> ()

public protocol BooksListsViewProtocol:class {
    
    func showMessageError(error: Error?, completion: ErrorMessageCompletion?)
    func showBooks(books: [BookViewEntity] )
}

public typealias BooksListsUIProtocol = BooksListsViewProtocol & TableLoadingIndicatorProtocol & AlertMessageProtocol

public struct BookViewEntity
{
    let id: String!
    let title: String!
    let authors: String!
    let urlBookImage : String?
}

public class BooksListViewController: UIViewController, BooksListsUIProtocol{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak public var tableView: UITableView?
    
    var mBooks: [BookViewEntity] = []
    
    public lazy var presenter: BooksListPresenter = { [unowned self] in
        return BooksListPresenter(withUI: self)
    }()
    
    public lazy var loadingIndicator: UIRefreshControl = { [unowned self] in
        // Initialize the refresh control.
        let control = UIRefreshControl(frame: .zero)
        control.backgroundColor = UIColor.purple
        control.tintColor = UIColor.white
        control.addTarget(self, action: #selector(refreshBooks), for: .valueChanged)
        return control
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //add refresh control to table (refresh control will be the loading indicator)
        tableView?.refreshControl = loadingIndicator
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 44.0
        tableView?.register(BookCell.classForCoder(), forCellReuseIdentifier: BookCell.identifier)
        tableView?.separatorStyle = .none
        
        searchBar.delegate = self
        
        //call to presenter to give a chance when view did load
        presenter.viewDidLoad()
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func showBooks(books: [BookViewEntity]) {
        mBooks = books
        tableView?.separatorStyle = .singleLine
        tableView?.reloadData()
    }

    public func refreshBooks()
    {
        presenter.askForBooks(filter: searchBar.text ?? "")
    }
    
    public func showEmptyMessage()
    {
        // Display a message when the table is empty
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView?.bounds.size.width ?? 0, height: self.tableView?.bounds.size.height ?? 0))
        
        messageLabel.text = NSLocalizedString("GBS_NO_BOOKS_AVAILABLE", comment: "")
        messageLabel.textColor = UIColor.black;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 20);
        messageLabel.sizeToFit()
        tableView?.backgroundView = messageLabel;
        tableView?.separatorStyle = .none;
    }
}


//MARK : Message Error Management
extension BooksListViewController
{
    public func showMessageError(error: Error?, completion: ErrorMessageCompletion?)
    {
        showAlertMessage(fromView: self, error: error, completion: completion)
    }
}

//MARK: Table View Data Source Handler
extension BooksListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mBooks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath as IndexPath) as! BookCell
        
        //pass data to cell from the related book
        cell.bindBook(book: mBooks[indexPath.row], presenter: presenter)
        
        return cell
    }
}

// MARK: Table View Delegate Handler
extension BooksListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: call to presenter with index path of selected cell
    }
}

extension BooksListViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        presenter.askForBooks(filter: searchBar.text ?? "")
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

