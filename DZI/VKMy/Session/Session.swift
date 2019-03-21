//
//  Session.swift
//  VKMy
//
//  Created by NadiaMorozova on 20.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Foundation
import UIKit

class Session {
    private init() {}
    public static let shared = Session()
   
    var token: String = ""
    var userId: Int = 0
    var friendId: Int = 0
    //var id: Int = 0
}
