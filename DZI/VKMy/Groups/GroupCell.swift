//
//  GroupCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 13.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var photoGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoGroup.layer.cornerRadius = 40
        self.photoGroup.clipsToBounds = false
        self.photoGroup.layer.shadowOffset = CGSize.zero
        self.photoGroup.layer.shadowRadius = 10
        self.photoGroup.layer.shadowOpacity = 1
        self.photoGroup.contentMode = .scaleAspectFit
        self.photoGroup.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
       public func configure(with groups: Group) {
        self.nameGroup.text = groups.groupName
        self.photoGroup.kf.setImage(with: URL(string: groups.imageGroup))
      
    }
}
