//
//  NewsCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 22.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

protocol CellForButtonsDelegate {
    func didTapCompleteButton(indexPath: IndexPath)
}

class NewsCell: UICollectionViewCell {
    static let reuseId = "NewsCell"
    @IBOutlet weak var ViewOne: NewsCell!
    @IBOutlet weak var photoNews: UIImageView! {
        didSet {
            photoNews.translatesAutoresizingMaskIntoConstraints = false
            photoNews.sizeToFit()
        }
    }
    @IBOutlet weak var textNews: UILabel!{
        didSet {
            textNews.translatesAutoresizingMaskIntoConstraints = false
            textNews.numberOfLines = 0
            textNews.lineBreakMode = .byWordWrapping
            textNews.font = UIFont(name: "System", size: 15)
        }
    }
    @IBOutlet weak var dataAdd: UILabel! {
        didSet {
            dataAdd.translatesAutoresizingMaskIntoConstraints = true
            dateFrame()
        }
    }
    @IBOutlet weak var userName: UILabel! {
        didSet {
            userName.translatesAutoresizingMaskIntoConstraints = true
            userName.lineBreakMode = .byWordWrapping
            userName.numberOfLines = 0
            nameFrame()
        }
    }
    @IBOutlet weak var user: UIImageView! {
        didSet {
            user.translatesAutoresizingMaskIntoConstraints = true
            user.layer.shadowOffset = .zero
            user.layer.cornerRadius = 40
            user.clipsToBounds = false
            user.layer.shadowOffset = CGSize.zero
            user.contentMode = .scaleAspectFit
            user.layer.masksToBounds = true
            user.layer.shadowOpacity = 0.75
            user.layer.shadowRadius = 6
            self.user?.frame = CGRect.init(x: 5, y: 10, width: 80, height: 80)
            
        }
    }
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var letterButton: UIButton!
    @IBOutlet weak var letter: UILabel!
    @IBOutlet weak var sendButtonus: UIButton!
    @IBOutlet weak var send: UILabel!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var eye: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupText()
    }
    
    func nameFrame() {
        
        let nameSize: CGFloat = 50
        let name = CGSize(width: 250, height: nameSize)
        let nameOrigin = CGPoint(x: 110.0 , y: 6.0)
        
        DispatchQueue.main.async {
            self.userName?.frame = CGRect(origin: nameOrigin, size: name)
        }
    }
    
    func dateFrame() {
        
        let dateSize: CGFloat = 50
        let date = CGSize(width: 250, height: dateSize)
        let dateOrigin = CGPoint(x: 110.0 , y: 33.0)
        
        DispatchQueue.main.async {
            self.dataAdd?.frame = CGRect(origin: dateOrigin, size: date)
        }
    }
    
    func setupName() {
        
        userName?.leftAnchor.constraint(equalTo: user.leftAnchor, constant:  50).isActive = false
        userName?.topAnchor.constraint(equalTo: ViewOne.bottomAnchor, constant:  70).isActive = true
        userName?.rightAnchor.constraint(equalTo: ViewOne.rightAnchor, constant:  -10).isActive = true
        userName?.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupDate() {
        
        dataAdd?.leftAnchor.constraint(equalTo: user.leftAnchor, constant:  30).isActive = true
        dataAdd?.topAnchor.constraint(equalTo: userName.bottomAnchor, constant:  10).isActive = true
        dataAdd?.rightAnchor.constraint(equalTo: ViewOne.rightAnchor, constant:  -10).isActive = true
        
        dataAdd?.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupUser() {
        
        user?.leftAnchor.constraint(equalTo: ViewOne.leftAnchor, constant:  10).isActive = true
        user?.topAnchor.constraint(equalTo: ViewOne.bottomAnchor, constant:  10).isActive = true
        user?.rightAnchor.constraint(equalTo: ViewOne.rightAnchor, constant:  -80).isActive = true
        
        user?.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupText() {
        
        textNews?.leftAnchor.constraint(equalTo: ViewOne.leftAnchor, constant:  10).isActive = true
        textNews?.topAnchor.constraint(equalTo: user.bottomAnchor, constant:  10).isActive = true
        textNews?.rightAnchor.constraint(equalTo: ViewOne.rightAnchor, constant:  -10).isActive = true
       
        if textNews?.numberOfLines == 1 || textNews?.numberOfLines == 0 {
            textNews?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else  {
            textNews?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
    }
    
    func setupPhoto() {
        
        photoNews?.leftAnchor.constraint(equalTo: ViewOne.leftAnchor, constant:  10).isActive = true
        photoNews?.topAnchor.constraint(equalTo: textNews.bottomAnchor, constant:  10).isActive = true
        photoNews?.rightAnchor.constraint(equalTo: ViewOne.rightAnchor, constant:  -10).isActive = true
        
        photoNews?.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func iconFrame() {
        
        let iconSize: CGFloat = 50
        let icon = CGSize(width: iconSize, height: iconSize)
        let iconOrigin = CGPoint(x: 10.0 , y: 3.0)
        
        DispatchQueue.main.async {
            self.user?.frame = CGRect(origin: iconOrigin, size: icon)
        }
    }
    
    public func configPhotoNews(with photo: News){
        
        textNews.sizeToFit()
        letter.text = photo.repostsCount
        eye.text = photo.viewsCount
        photoNews.kf.setImage(with: URL(string: photo.photoNews))
        like.text = photo.likesCount
        textNews.text = photo.contentText
        
        if textNews.intrinsicContentSize.height > 100 {
            let showMoreButton = UIButton()
            showMoreButton.backgroundColor = .gray
            showMoreButton.setTitle("Show More...", for: [])
            textNews.addSubview(showMoreButton)
            
            showMoreButton.snp.makeConstraints { make in
                make.right.equalTo(10)
                make.top.equalTo(5)
                make.height.equalTo(20)
                make.bottom.equalToSuperview()
            }
            
            textNews.snp.makeConstraints { make in
                make.height.lessThanOrEqualTo(100)
            }
        }
    }
    public func configPhotoGoup(with photo: Group){
        user.kf.setImage(with: URL(string: photo.imageGroup))
        userName.text = photo.groupName
        
    }
    override func prepareForReuse() {
        textNews.subviews.forEach { $0.removeFromSuperview() }
        
    }
    
    
    
    
    
    //          _//_//_//_
    
    
    
    
    
    
    public func configure(with item: News, completion: @escaping () -> Void) {
        
        let attrStr = try! NSAttributedString(data: (item.contentText.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [.documentType: NSAttributedString.DocumentType.html],  documentAttributes: nil)
        textNews.attributedText = attrStr
        
    }
    
    public func config(news: News, profile: User, group: Group) {
        
        userName.text = String(profile.author)
        textNews.text = news.contentText
        letter.text = String(news.commentsCount)
        send.text = String(news.repostsCount)
        eye.text = String(news.viewsCount)
        like.text = String(news.likesCount)
        user.kf.setImage(with: URL(string: profile.imageString))
        user.kf.setImage(with: URL(string: group.imageGroup))
    }
    func configure(author: String, photoUrl: String, userPhoto: User, text: String, likes: Int, comments: Int, reposts: Int, watches: Int) {
        
        self.userName.text = author
        let url = URL(string: photoUrl)
        self.user.kf.setImage(with: url)
        self.textNews.text = text
        self.like.tag = likes
        //self.likeButton.tag = userLikes
        self.letter.tag = comments
        self.send.tag = reposts
        self.eye.tag  = watches
        // self.user.kf.setImage(with: URL(string: photoUrl))
        self.user.kf.setImage(with: URL(string: userPhoto.imageString))
    }
    
    public func configPhotoUser(with userStr: User){
        user.kf.setImage(with: URL(string: userStr.imageString))
        userName.text = userStr.firstName
        
    }
    
    
    public var commentsCount = 0 {
        didSet {
            letter.text = "\(commentsCount)"
        }
    }
    public var repostsCount = 0 {
        didSet {
            send.text = "\(repostsCount)"
        }
    }
    public var watchesCount = 0 {
        didSet {
            eye.text = "\(watchesCount)"
        }
    }
    
    public func configures(with item: News, completion: @escaping () -> Void) {
        
        let attrStr = try! NSAttributedString(data: (item.contentText.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [.documentType: NSAttributedString.DocumentType.html],  documentAttributes: nil)
        textNews.attributedText = attrStr
        
        if item.sourceId < 0, let group = item.group {
            self.userName.text = group.groupName
            self.user.kf.setImage(with: NetworkService.urlForIcon(group.imageGroup))
        } else if item.sourceId > 0, let user = item.user {
            self.userName.text = user.surName
            self.user.kf.setImage(with: NetworkService.urlForIcon(user.imageString))
        } else {
            self.userName.text = ""
            self.user.image = UIImage(contentsOfFile: "emptyImage.png")
        }
        
        if item.type == "photo" {
            self.eye.isHidden = true
        } else {
            self.eye.isHidden = false
        }
        user.kf.setImage(with: URL(string:item.photoNews)) { _ in
            completion()
        }
    }
}
