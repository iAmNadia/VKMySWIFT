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
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
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
    static let offset: CGFloat = 8
    private var textHeight: CGFloat = 0
    private let offset: CGFloat = 8
    
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
    func texxtFrame() {
        
        let dateSize: CGFloat = 50
        let date = CGSize(width: 250, height: dateSize)
        let dateOrigin = CGPoint(x: 10.0 , y: 96.0 )
        
        DispatchQueue.main.async {
            self.textNews?.frame = CGRect(origin: dateOrigin, size: date)
        }
    }
    
    public func configPhotoNews(with photo: News){
        
        textNews.text = photo.contentText
        textNews.sizeToFit()
        letter.text = photo.repostsCount
        eye.text = photo.viewsCount
        like.text = photo.likesCount
        
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
        
        photoNews.kf.setImage(with: URL(string: photo.photoNews))
        if photo.photoNews.isEmpty {
            self.photoHeightConstraint = nil
        }
        
        if photo.contentText.isEmpty {
            self.textHeightConstraint = nil
        }
    }
    public func configPhotoGoup(with photo: Group){
        
        user.kf.setImage(with: URL(string: photo.imageGroup))
        userName.text = photo.groupName
        
    }
    public func configPhotoUser(with photo: User){
        
        user.kf.setImage(with: URL(string: photo.imageString))
        userName.text = photo.author
        
    }
    
    override func prepareForReuse() {
        textNews.subviews.forEach { $0.removeFromSuperview() }
    }
}





