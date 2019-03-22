//
//  TextNewsViewController.swift
//  VKMy
//
//  Created by NadiaMorozova on 22.03.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import UIKit

class TextNewsViewController: UIView {

    @IBOutlet var Vview: UIView!
    @IBOutlet weak var Text: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        textInit()
    }
    
    func textInit() {
     Bundle.main.loadNibNamed("TextNewsViewController", owner: self, options: nil)
        addSubview(Vview)
        Vview.frame = self.bounds
        Vview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
   
}
