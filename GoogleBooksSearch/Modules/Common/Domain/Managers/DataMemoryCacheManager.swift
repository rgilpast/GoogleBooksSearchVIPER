//
//  ImageCacheManager.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 27.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit


public final class DataMemoryCacheManager: DataCacheManagerProtocol {
    
    static let sharedInstance: DataMemoryCacheManager = DataMemoryCacheManager()
    
    fileprivate init() {}
    
    lazy public var items: [String : Data] = {
        return [:]
    }()
    
    public func getDataItem(withKey: String) -> Data? {
        return items[withKey]
    }
    
    public func setDataItem(dataItem: Data, withKey: String) {
        items[withKey] = dataItem
    }
    
    public func clear() {
        items.removeAll()
    }

}
