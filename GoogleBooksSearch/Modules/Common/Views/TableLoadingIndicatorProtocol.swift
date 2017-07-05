//
//  TableLoadingIndicatorProtocol.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 27/4/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol TableLoadingIndicatorProtocol: LoadingIndicatorProtocol {
    
    var tableView: UITableView? { get }
    var loadingIndicator: UIRefreshControl { get }
}

//MARK : Loading Indicator
public extension TableLoadingIndicatorProtocol
{
    func showLoadingIndicator() {
        //show loading indicator only if it isn´t displaying
        if !loadingIndicator.isRefreshing {
            loadingIndicator.beginRefreshing()
        }
    }
    func hideLoadingIndicator() {
        //hide loading indicator only if it is still displaying
        if loadingIndicator.isRefreshing {
            tableView?.reloadData()
            loadingIndicator.endRefreshing()
        }
    }
}
