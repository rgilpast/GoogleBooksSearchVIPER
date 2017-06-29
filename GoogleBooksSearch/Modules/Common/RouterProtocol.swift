//
//  RouterProtocol.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 29.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol RouterProtocol {
    static func create(withInfo info: Any?) -> UIViewController?
}

extension RouterProtocol {
    
    static func createViewInstance(witViewId: String, fromStoryboard storyBoardName: String) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: witViewId)
        return view
    }
}
