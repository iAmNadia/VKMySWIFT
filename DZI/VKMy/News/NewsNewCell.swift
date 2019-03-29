//
//  NewsNewCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 29.03.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//


import UIKit

class NewsCellBody: UIView {
    
    static let reuseId = "NewsCellBodyId"
    
    var postViewHeight: CGFloat {
        return  self.postHeight + self.photoScaledHeight + self.offset
    }
    
    private let postText = UITextView()
    
    private let postPhoto: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = .white
        return icon
    }()
    
    private let offset: CGFloat = 8
    private let defaultFont = UIFont.systemFont(ofSize: 12)
    
    private var photoWidth: CGFloat = 0
    private var photoHeight: CGFloat = 0
    
    private var postHeight: CGFloat = 0
    private var photoScaledHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        postText.backgroundColor = .white
        postText.font = defaultFont
        postText.isScrollEnabled = false
        self.addSubview(postText)
        self.addSubview(postPhoto)
    }
    
    public func configure(with item: News, at indexPath: IndexPath, by photoService: PhotoService?) {
        let attrStr = try! NSAttributedString(data: (item.contentText.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [.documentType: NSAttributedString.DocumentType.html],  documentAttributes: nil)
        postText.attributedText = attrStr
        photoWidth = CGFloat(item.photoWidth)
        photoHeight = CGFloat(item.photoHeight)
        postPhoto.image = photoService?.photo(at: indexPath, by: item.photoNews)
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPostTextFrame()
        setPostPhotoFrame()
        self.frame = bounds
    }
    
    private func setPostTextFrame() {
        guard !postText.text.isEmpty, let font = postText.font else { return }
        let textSize = getTextSize(text: postText.text, font: font)
        self.postHeight = textSize.height
        let textOrigin = CGPoint(x: self.frame.origin.x + self.offset,
                                 y: self.frame.origin.y)
        
        postText.frame = CGRect(origin: textOrigin, size: textSize)
    }
    
    private func setPostPhotoFrame() {
        guard photoWidth > 0 else {return}
        let scaledWidth = self.frame.size.width
        let ratio = scaledWidth / photoWidth
        self.photoScaledHeight = (photoHeight * ratio).rounded(.up)
        
        let imageSize = CGSize(width: scaledWidth, height: self.photoScaledHeight)
        
        let iconOrigin = CGPoint(x: self.frame.origin.x + self.offset,
                                 y: self.frame.origin.y + self.postHeight + self.offset)
        
        postPhoto.frame = CGRect(origin: iconOrigin, size: imageSize)
    }
    
    private func getTextSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.frame.width - 2 * offset
        let textblock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = text.boundingRect(with: textblock,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        
        let width = rect.size.width.rounded(.up)
        let height = rect.size.height.rounded(.up)
        
        return CGSize(width: width, height: height)
    }
}












//import UIKit
//import Kingfisher
//
//class NewsNewCell: UITableViewCell {
//    static let reuseId = "NewsNewCell"
//    static let offset: CGFloat = 8
//    static let avatarHeight: CGFloat = 50
//
//    //MARK: - Constants
//    private let offset: CGFloat = 8
//    private let avatarHeight: CGFloat = 50
//
//    //MARK: - Subviews
//    private let avatarImageView = UIImageView()
//    private let authorLabel = UILabel()
//    private let dataLabel = UILabel()
//    private let postLabel = UILabel()
//    private let attachmentImageView = UIImageView()
//
//    //MARK: - Variables
//    private var textHeight: CGFloat = 0
//    private var attachmentImageHeight: CGFloat = 0
//
//    //MARK: - Inits
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        contentView.addSubview(avatarImageView)
//        avatarImageView.contentMode = .scaleAspectFill
//
//        contentView.addSubview(authorLabel)
//        authorLabel.font = UIFont.systemFont(ofSize: 18)
//
//        contentView.addSubview(postLabel)
//        postLabel.numberOfLines = 0
//
//        contentView.addSubview(attachmentImageView)
//        attachmentImageView.contentMode = .scaleAspectFill
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        avatarImageView.frame = CGRect(x: offset,
//                                       y: offset,
//                                       width: avatarHeight,
//                                       height: avatarHeight)
//
//        authorLabel.frame = CGRect(x: offset + avatarHeight + offset,
//                                   y: offset,
//                                   width: bounds.width - (offset + avatarHeight + offset),
//                                   height: avatarHeight / 2)
//
//        dataLabel.frame = CGRect(x: offset + avatarHeight + offset,
//                                   y: offset + avatarHeight / 2 + 8,
//                                   width: bounds.width - (offset + avatarHeight + offset),
//                                   height: avatarHeight / 2)
//
//        postLabel.frame = CGRect(x: offset,
//                                 y: offset + avatarHeight,
//                                 width: bounds.width - 2*offset,
//                                 height: textHeight)
//
//        attachmentImageView.frame = CGRect(x: offset,
//                                           y: offset + avatarHeight + textHeight,
//                                           width: bounds.width - 2*offset,
//                                           height: attachmentImageHeight)
//    }
//
//    //MARK: Configure api
//    public func configure(with post: News, textHeight: CGFloat, imageHeight: CGFloat) {
//        //Setting author image and label
//        if post.id < 0, let group = post.group {
//            self.authorLabel.text = group.groupName
//            avatarImageView.kf.setImage(with: NetworkService.urlForIcon(group.imageGroup))
//        } else if post.id > 0, let user = post.user {
//            self.authorLabel.text = user.author
//            avatarImageView.kf.setImage(with: NetworkService.urlForIcon(user.imageString))
//        } else {
//            self.authorLabel.text = ""
//            avatarImageView.image = UIImage(contentsOfFile: "emptyImage.png")
//        }
//
//        //Setting post text data
//        self.textHeight = textHeight
//        guard let data = post.contentText.data(using: .unicode, allowLossyConversion: true) else { fatalError("Couldn't get text data") }
//        let attrStr = try? NSAttributedString(data: data,
//                                              options: [.documentType: NSAttributedString.DocumentType.html],
//                                              documentAttributes: nil)
//        postLabel.attributedText = attrStr
//
//        //Setting attachment image
//        self.attachmentImageHeight = imageHeight
//        attachmentImageView.kf.setImage(with: URL(string: post.photoNews))
//    }
//}
//
