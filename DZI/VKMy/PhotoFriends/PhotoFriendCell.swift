//
//  VKCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoFriendCell: UICollectionViewCell {
    @IBOutlet var photo: UIImageView!
    
    @IBAction func likePress(_ sender: Any) {
        onLike?(index)
    }
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    var index: Int = 0
    var onLike: ((Int) -> ())?
    
    // живое фото
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 1.0) {
                self.photo.transform = self.isSelected ? CGAffineTransform(scaleX: 1.3, y: 1.3) : CGAffineTransform.identity
                
            }
        }
    }
   
    
    func animateButton() {
        
        //  UIView.transition(from: likeCount, to: likeCount, duration: 0.2, options: .transitionCurlUp)
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 8
        animation.stiffness = 100
        animation.mass = 2
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.likeCount.layer.add(animation, forKey: nil)
    }
    public func configurePhoto(with friendses: VKPhotoAll){
//        self.likeCount.text = String(friendses.likes)
//        self.likeButton.setImage(UIImage(named: "Heart-1"), for: .normal)
        self.photo.kf.setImage(with: PhotoAllService.urlForIcon(friendses.photo))
        
       
    }
}
