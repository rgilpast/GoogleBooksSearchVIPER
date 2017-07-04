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
    func showBookDetail(detail: BookDetailViewEntity)
}

public typealias BookDetailUIProtocol = BookDetailViewProtocol & AlertMessageProtocol & LoadingIndicatorProtocol

fileprivate enum BookDetailCellType: Int {
    case MainInfo
    case SinopsisInfo
}

public class BookDetailViewController: UIViewController, BookDetailUIProtocol, ViewLoadingIndicatorProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var bookDetail: BookDetailViewEntity?
    
    fileprivate lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("GBS_DETAIL_BACK", comment: ""), style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        return button
    }()
    
    public lazy var loadingIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .whiteLarge
        return indicator
    }()
    
    
    public var presenter: BookDetailPresenter?

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("GBS_DETAIL_TITLE", comment: "")
        
        setupBackButton()
        setupTable()
        
        presenter?.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func showBookDetail(detail: BookDetailViewEntity) {
        
        bookDetail = detail
        tableView.reloadData()
    }
}

fileprivate extension BookDetailViewController {
    
    func setupTable() {
        
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 44.0
        tableView?.register(BookDetailMainInfoCell.classForCoder(), forCellReuseIdentifier: BookDetailMainInfoCell.identifier)
        tableView?.register(BookDetailAdditionalInfoCell.classForCoder(), forCellReuseIdentifier: BookDetailAdditionalInfoCell.identifier)
        tableView?.separatorStyle = .none
    }
    
    func setupBackButton() {
        
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped(_ sender : UIButton) {
        presenter?.back()
    }
}

//MARK : Message Error Management
extension BookDetailViewController {
    
    public func showMessageError(error: Error?, completion: AlertMessageCompletion?)
    {
        showAlertMessage(fromView: self, error: error, completion: completion)
    }
}


//MARK: Table View Data Source Handler
extension BookDetailViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let detail = bookDetail else {
            return 0
        }
        //description is the main additional info. Check if detail comes with additional info
        guard let _ = detail.sinopsis else {
            return BookDetailCellType.MainInfo.rawValue + 1
        }
        return BookDetailCellType.SinopsisInfo.rawValue + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if indexPath.row == BookDetailCellType.MainInfo.rawValue {
            
            let mainCell = tableView.dequeueReusableCell(withIdentifier: BookDetailMainInfoCell.identifier, for: indexPath as IndexPath) as! BookDetailMainInfoCell
            //pass data to cell from the related book
            mainCell.bindBook(withDetail: bookDetail, presenter: presenter)
            cell = mainCell
        } else {
            let additionalCell = tableView.dequeueReusableCell(withIdentifier: BookDetailAdditionalInfoCell.identifier, for: indexPath as IndexPath) as! BookDetailAdditionalInfoCell
            //pass data to cell from the related book
            additionalCell.bindBook(withDetail: bookDetail)
            cell = additionalCell
        }
        return cell
    }
}

fileprivate struct BookDetailViewControllerConstants {
    static let mainInfoCellIndex: UInt = 0
    static let additionalInfoCellIndex: UInt = 1
}
