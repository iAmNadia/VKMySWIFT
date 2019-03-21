//
//  AllGroups.swift
//  VKMy
//
//  Created by NadiaMorozova on 10.01.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift


final class SearchGroups: Object, VkFetchable {
    
    static var parameters: Parameters = [:]

    static func parseJSON(json: JSON) -> SearchGroups{
        let group = SearchGroups(json: json)
        return group
    }

    static var path: String {
        return "/method/groups.search"
    }
    @objc dynamic var id = 0
    @objc dynamic var groupName = ""
    @objc dynamic var search = ""
    @objc dynamic var imageGroup = ""

    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.search = json["screen_name"].stringValue
        self.imageGroup = json["photo_50"].stringValue
      
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
