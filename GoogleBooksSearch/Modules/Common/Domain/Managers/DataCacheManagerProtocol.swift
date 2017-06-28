//
//  MemoryCacheManager.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 27.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol DataCacheManagerProtocol {
    
    var items: [String : Data] { get }
    
    func getDataItem(withKey: String) -> Data?
    func setDataItem(dataItem: Data, withKey: String)
    func clear()
}
