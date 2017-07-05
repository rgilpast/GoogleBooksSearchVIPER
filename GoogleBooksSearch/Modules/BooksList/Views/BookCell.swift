//
//  BookCell.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit


public class BookCell: UITableViewCell
{
    static let identifier: String = "BookCell"
    
    lazy var title: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var detail: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.textColor = UIColor.darkText
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var thumbnail: UIImageView = {
        var bookImage = UIImageView(frame: .zero)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        bookImage.contentMode = .scaleAspectFill
        //assign by default image
        bookImage.image = UIImage(named: "generic_book")
        return bookImage
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
    
    public func bindBook(book: BookViewEntity?, presenter: BooksListPresenterProtocol?)
    {
        title.text =  book?.title
        title.sizeToFit()
        
        detail.text =  book?.authors
        detail.sizeToFit()
        
        presenter?.askForBookImage(book: book, onCompletion: {[weak self] (imageData) -> (Void) in
            if let data = imageData
            {
                self?.thumbnail.image = UIImage(data: data)
            }
        })
    }
}

private extension BookCell {
    
    func setupCell() {
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        clipsToBounds = true
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(title)
        contentView.addSubview(detail)

        setupThumbnail()
        setupTitle()
        setupDetail()
    }
    
    func setupThumbnail() {
        thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BookCellConstants.thumbnailLeftMargin).isActive = true
        thumbnail.heightAnchor.constraint(equalToConstant: BookCellConstants.thumbnailSize).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setupTitle() {
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BookCellConstants.titleMarginSize).isActive = true
        title.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: BookCellConstants.titleMarginSize).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookCellConstants.titleMarginSize).isActive = true
        title.bottomAnchor.constraint(equalTo: detail.topAnchor, constant: -BookCellConstants.titleMarginSize).isActive = true
        title.setContentCompressionResistancePriority(1000, for: .vertical)
        title.setContentHuggingPriority(1000, for: .vertical)
    }
    
    func setupDetail() {
        detail.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: BookCellConstants.detailMarginSize).isActive = true
        detail.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BookCellConstants.detailMarginSize).isActive = true
        detail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -BookCellConstants.detailBottomMarginSize).isActive = true
        detail.setContentCompressionResistancePriority(1000, for: .vertical)
        detail.setContentHuggingPriority(1000, for: .vertical)
    }
}

private struct BookCellConstants {
    static let titleMarginSize: CGFloat = 4.0
    static let detailMarginSize: CGFloat = 4.0
    static let detailBottomMarginSize: CGFloat = 8.0
    static let thumbnailLeftMargin: CGFloat = 4.0
    static let thumbnailSize: CGFloat = 32.0
}
