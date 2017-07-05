//
//  BookDetailAdditionalInfoCell.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 30.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class BookDetailAdditionalInfoCell: UITableViewCell {
    
    static let identifier: String = "BookDetailAdditionalInfoCell"
    
    fileprivate lazy var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: BookDetailAdditionalInfoCellConstants.titleFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = NSLocalizedString("GBS_DETAIL_SINOPSIS", comment: "")
        return label
    }()
    
    fileprivate lazy var sinopsisLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: BookDetailAdditionalInfoCellConstants.sinopsisFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    public init() {
        super.init(style: .default, reuseIdentifier: BookCell.identifier)
        setupCell()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: BookCell.identifier)
        setupCell()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

}

public extension BookDetailAdditionalInfoCell {

    public func bindBook(withDetail detail: BookDetailViewEntity?)
    {
        sinopsisLabel.text = detail?.sinopsis?.html2String
        sinopsisLabel.sizeToFit()
    }
    
}

private extension BookDetailAdditionalInfoCell {
    
    func setupCell() {
        
        selectionStyle = .none
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(sinopsisLabel)

        setupTitle()
        setupSinospsis()
    }

    func setupTitle() {
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BookDetailAdditionalInfoCellConstants.titleTopMargin).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailAdditionalInfoCellConstants.titleLeftMargin).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailAdditionalInfoCellConstants.titleRighttMargin).isActive = true
        titleLabel.setContentCompressionResistancePriority(1000, for: .vertical)
    }
    
    func setupSinospsis() {
        
        sinopsisLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: BookDetailAdditionalInfoCellConstants.sinopsisTopMargin).isActive = true
        sinopsisLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailAdditionalInfoCellConstants.sinopsisLeftMargin).isActive = true
        sinopsisLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailAdditionalInfoCellConstants.sinopsisRighttMargin).isActive = true
        sinopsisLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: BookDetailAdditionalInfoCellConstants.sinopsisBottomMargin).isActive = true
        sinopsisLabel.setContentCompressionResistancePriority(1000, for: .vertical)
    }

}

private struct BookDetailAdditionalInfoCellConstants {
    
    static let titleFontSize: CGFloat = 14.0
    static let titleTopMargin: CGFloat = 8.0
    static let titleRighttMargin: CGFloat = 16.0
    static let titleLeftMargin: CGFloat = -16.0
    
    static let sinopsisFontSize: CGFloat = 14.0
    static let sinopsisTopMargin: CGFloat = 8.0
    static let sinopsisBottomMargin: CGFloat = -16.0
    static let sinopsisRighttMargin: CGFloat = -16.0
    static let sinopsisLeftMargin: CGFloat = 16.0
}
