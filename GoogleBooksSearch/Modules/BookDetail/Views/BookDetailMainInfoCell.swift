//
//  BookDetailMainInfoCell.swift
//  GoogleBooksSearch
//
//  Created by Gil Pastor, Rafael on 30.06.17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public class BookDetailMainInfoCell: UITableViewCell {
    
    static let identifier: String = "BookDetailMainInfoCell"
    
    lazy var coverImage: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var title: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: BookDetailMainInfoCellConstants.titleFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var subtitle: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: BookDetailMainInfoCellConstants.subTitleFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var authors: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: BookDetailMainInfoCellConstants.authorsFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var publishInfo: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: BookDetailMainInfoCellConstants.publisherFontSize)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var categoryAndPageCount: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: BookDetailMainInfoCellConstants.mainCategoryFontSize)
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
    
    public func bindBook(withDetail detail: BookDetailViewEntity?, presenter: BookDetailPresenterProtocol?)
    {
        title.text = detail?.title
        title.sizeToFit()
        
        subtitle.text = detail?.subtitle
        subtitle.sizeToFit()
        
        authors.text = detail?.authors
        authors.sizeToFit()

        publishInfo.text = detail?.publishInfo
        publishInfo.sizeToFit()

        categoryAndPageCount.text = detail?.categoryAndPageCount
        categoryAndPageCount.sizeToFit()
        
        coverImage.showLoadingIndicator()

        //ask for the cover image
        presenter?.askForBookImage(book: detail, onCompletion: {[weak self] (imageData) -> (Void) in
            
            self?.coverImage.hideLoadingIndicator()
            
            if let data = imageData
            {
                self?.coverImage.image = UIImage(data: data)
            } else {
                self?.coverImage.image = UIImage(named: "generic-book")
            }
        })
    }
}

private extension BookDetailMainInfoCell {
    
    func setupCell() {
        
        selectionStyle = .none
        clipsToBounds = true
        
        contentView.addSubview(coverImage)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(authors)
        contentView.addSubview(publishInfo)
        contentView.addSubview(categoryAndPageCount)

        setupCoverImage()
        setupTitle()
        setupSubtitle()
        setupAuthors()
        setupPublishInfo()
        setupCategoryAndPageCount()
    }
    
    func setupCoverImage() {
        
        coverImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BookDetailMainInfoCellConstants.coverImageTopMargin).isActive = true
        coverImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: BookDetailMainInfoCellConstants.coverImageWidthFactor).isActive = true
        coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor, multiplier: BookDetailMainInfoCellConstants.coverImageAspectRatio).isActive = true
        coverImage.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: BookDetailMainInfoCellConstants.coverImageBottomMargin)
        coverImage.setContentCompressionResistancePriority(1000, for: .vertical)
    }
    
    func setupTitle() {
        
        title.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: BookDetailMainInfoCellConstants.titleTopMargin).isActive = true
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailMainInfoCellConstants.titleLeftMargin).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailMainInfoCellConstants.titleRightMargin).isActive = true
        title.setContentCompressionResistancePriority(1000, for: .vertical)
    }
    
    func setupSubtitle() {
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: BookDetailMainInfoCellConstants.subtitleTopMargin).isActive = true
        subtitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailMainInfoCellConstants.subtitleLeftMargin).isActive = true
        subtitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailMainInfoCellConstants.subtitleRightMargin).isActive = true
        subtitle.setContentCompressionResistancePriority(1000, for: .vertical)
    }
    
    func setupAuthors() {

        authors.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: BookDetailMainInfoCellConstants.authorsTopMargin).isActive = true
        authors.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailMainInfoCellConstants.authorsLeftMargin).isActive = true
        authors.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailMainInfoCellConstants.authorsRightMargin).isActive = true
        authors.setContentCompressionResistancePriority(1000, for: .vertical)
    }
    
    func setupPublishInfo() {
        
        publishInfo.topAnchor.constraint(equalTo: authors.bottomAnchor, constant: BookDetailMainInfoCellConstants.publishInfoTopMargin).isActive = true
        publishInfo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailMainInfoCellConstants.publishInfoLeftMargin).isActive = true
        publishInfo.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailMainInfoCellConstants.publishInfoRightMargin).isActive = true
        publishInfo.setContentCompressionResistancePriority(1000, for: .vertical)
    }

    func setupCategoryAndPageCount() {
        
        categoryAndPageCount.topAnchor.constraint(equalTo: publishInfo.bottomAnchor, constant: BookDetailMainInfoCellConstants.categoryTopMargin).isActive = true
        categoryAndPageCount.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookDetailMainInfoCellConstants.categoryLeftMargin).isActive = true
        categoryAndPageCount.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookDetailMainInfoCellConstants.categoryRightMargin).isActive = true
        categoryAndPageCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: BookDetailMainInfoCellConstants.categoryBottomMargin).isActive = true
        categoryAndPageCount.setContentCompressionResistancePriority(1000, for: .vertical)
    }

}

private struct BookDetailMainInfoCellConstants {
    
    static let coverImageTopMargin: CGFloat = 8.0
    static let coverImageBottomMargin: CGFloat = 4.0
    static let coverImageLeftMargin: CGFloat = 4.0
    static let coverImageWidthFactor: CGFloat = 0.66
    static let coverImageAspectRatio: CGFloat = 1.0
    
    static let titleFontSize: CGFloat = 18.0
    static let subTitleFontSize: CGFloat = 14.0
    static let authorsFontSize: CGFloat = 14.0
    static let publisherFontSize: CGFloat = 12.0
    static let publishDateFontSize: CGFloat = 12.0
    static let mainCategoryFontSize: CGFloat = 12.0
    static let pageCountFontSize: CGFloat = 12.0
    
    static let titleTopMargin: CGFloat = 8.0
    static let titleLeftMargin: CGFloat = 16.0
    static let titleRightMargin: CGFloat = -16.0

    static let subtitleTopMargin: CGFloat = 4.0
    static let subtitleLeftMargin: CGFloat = 16.0
    static let subtitleRightMargin: CGFloat = -16.0

    static let authorsTopMargin: CGFloat = 4.0
    static let authorsLeftMargin: CGFloat = 16.0
    static let authorsRightMargin: CGFloat = -16.0
    
    static let publishInfoTopMargin: CGFloat = 4.0
    static let publishInfoLeftMargin: CGFloat = 16.0
    static let publishInfoRightMargin: CGFloat = -16.0
    
    static let categoryTopMargin: CGFloat = 4.0
    static let categoryBottomMargin: CGFloat = -8.0
    static let categoryLeftMargin: CGFloat = 16.0
    static let categoryRightMargin: CGFloat = -16.0
}
