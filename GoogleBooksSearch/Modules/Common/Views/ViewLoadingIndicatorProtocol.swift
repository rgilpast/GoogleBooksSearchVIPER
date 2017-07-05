//
//  ViewLoadingIndicatorProtocol.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 03.07.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewLoadingIndicatorProtocol: LoadingIndicatorProtocol {
    
    var view: UIView! { get }
}

//MARK : Loading Indicator
public extension ViewLoadingIndicatorProtocol
{
    func showLoadingIndicator() {
        view.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        view.hideLoadingIndicator()
    }
}
