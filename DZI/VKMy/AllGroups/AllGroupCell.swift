//
//  AllCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit

class AllGroupCell: UITableViewCell {

    @IBOutlet weak var vkName: UILabel!
    
    @IBOutlet weak var photoGroup: UIImageView!
    var groupFilter = [SearchGroups]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoGroup.layer.cornerRadius = 40
        self.photoGroup.clipsToBounds = true
        // cell.photoGroup.layer.masksToBounds = false
        self.photoGroup.layer.shadowOffset = CGSize.zero
        self.photoGroup.layer.shadowRadius = 10
        self.photoGroup.layer.shadowOpacity = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }
    public func configure(with user: SearchGroups) {
        self.vkName.text = user.groupName
        self.photoGroup.kf.setImage(with: URL(string: user.imageGroup))
       // print(vkName.text)
        print(user.imageGroup)
    }
}
