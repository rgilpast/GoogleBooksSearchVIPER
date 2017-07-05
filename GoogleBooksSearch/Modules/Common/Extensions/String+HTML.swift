//
//  String+HTML.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 04.07.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var html2AttributedString: NSAttributedString? {
        
        guard let data = data(using: String.Encoding.utf8) else {
            return nil
        }
        
        do {
            
            return try NSAttributedString(data: data, options:
                [
                NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
