//
//  PhotoNews.swift
//  VKMy
//
//  Created by NadiaMorozova on 28.02.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import UIKit

class PhotoNews: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let originalImage = image {
            let width = originalImage.size.width
            let height = originalImage.size.height
            let scaledWidth = frame.size.width
            
            let ratio = scaledWidth/width
            let scaledHeight = height * ratio
            
            return CGSize(width: scaledWidth, height: scaledHeight)
        }
        
        return .zero
    }
}
