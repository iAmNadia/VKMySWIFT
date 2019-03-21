//
//  MyCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    
    @IBOutlet weak var vkName: UILabel!
    
    @IBOutlet weak var vkSurname: UILabel!
    @IBOutlet weak var myView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.myView.layer.cornerRadius = 40
        self.myView.contentMode = .scaleAspectFit
        self.myView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    public func configure(with user: User) {
        //self.vkName.text = String(format: "%.0f", user.firstName, user.surName)
        self.vkName.text = user.firstName
        self.vkSurname.text = user.surName
        self.myView.kf.setImage(with: URL(string: user.imageString))
        
   }
}
