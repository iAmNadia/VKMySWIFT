//
//  Photo.swift
//  VKMy
//
//  Created by NadiaMorozova on 24.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Foundation
import SwiftyJSON

struct info : Decodable {
    let list : [lists]
}
struct lists : Decodable{
    let title : String?
    let images : [String]?
}


