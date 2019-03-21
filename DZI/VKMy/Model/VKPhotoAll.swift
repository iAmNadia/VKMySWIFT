//
//  Test.swift
//  VKMy
//
//  Created by NadiaMorozova on 26.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RealmSwift

 class VKPhotoAll: Object {

    enum Properties: String {
        case id
        case name
        case likes
        case count
        case photo
        case lincUser
    }
    
    @objc dynamic var count: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var likes: Bool = false
    @objc dynamic var like: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var photo = ""
    @objc dynamic var userId: Int = 0
    
    let lincUser = LinkingObjects(fromType: User.self, property: User.Properties.photos.rawValue)
    
    static func parseJSON(json: JSON) -> VKPhotoAll {
        let photo = VKPhotoAll(json: json)
        return photo
    }
    
    convenience init (id ind: Int, userId uid: Int, image img: String, likes lks: Int, liked flg: Bool) {
        self.init()
        self.id = ind
        self.userId = uid
        self.photo = img
        self.count = lks
        self.likes = flg
    }
    
   convenience init(json: JSON) {
        self.init()

        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.like = json["likes"]["user_likes"].intValue //== 0 ? false : true
        self.count = json["likes"]["count"].intValue
        self.photo = json["sizes"][2]["url"].stringValue
         self.userId = json["owner_id"].intValue
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
