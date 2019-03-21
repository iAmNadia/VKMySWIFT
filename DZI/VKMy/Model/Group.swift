//
//  Groups.swift
//  VKMy
//
//  Created by NadiaMorozova on 24.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

enum Properties: String {
    case id
    case groupName
    case screenName
    case imageGroup
    case groupMy
}

final class Group: Object, VkFetchable {
    static func parseJSON(json: JSON) -> Group{
        let group = Group(json: json)
        return group
    }
    
    static var path: String {
        return "/method/groups.get"
    }
    static var parameters: Parameters {
        return [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields": "nickname, domain, sex, bdate, city, country, timezone, photo_50, online",
            "v": "5.80"
        ]
    }
   @objc dynamic var id = 0
   @objc dynamic var groupName = ""
   @objc dynamic var screenName = ""
   @objc dynamic var imageGroup = ""
   @objc dynamic var groupMy = ""
  
    
   convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.screenName = json["screen_name"].stringValue
        self.imageGroup = json["photo_50"].stringValue
   
    }
    override static func primaryKey() -> String? {
        return "id"
    }

//    override static func primaryKey() -> String? {
//        return Properties.groupName.rawValue
//  }
}

