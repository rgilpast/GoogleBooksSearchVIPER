//
//  BookCell.swift
//  GoogleBooksSearch
//
//  Created by Rafael Gil Pastor on 5/3/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit


class BookCell: UITableViewCell
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
    
    required init?(coder aDecoder: NSCoder) {
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
        
        if let bookImageURL = book?.urlBookImage
        {
            presenter?.askForBookImage(bookImageURL: bookImageURL, onCompletion: {[weak self] (imageData) -> (Void) in
                if let data = imageData
                {
                    self?.thumbnail.image = UIImage(data: data)
                }
            })
        }
    }
}

private extension BookCell {
    
    func setupCell() {
        
        selectionStyle = .none
        
        setupThumbnail()
        setupTitle()
        setupDetail()
    }
    
    func setupThumbnail() {
        contentView.addSubview(thumbnail)
        thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        thumbnail.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
        thumbnail.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setupTitle() {
        contentView.addSubview(title)
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        title.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 4).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 4).isActive = true
    }
    
    func setupDetail() {
        contentView.addSubview(detail)
        detail.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        detail.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 4).isActive = true
        detail.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 4).isActive = true
        detail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
    }
}
