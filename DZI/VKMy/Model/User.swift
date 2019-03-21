//
//  User.swift
//  VKMy
//
//  Created by NadiaMorozova on 24.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//
//
import Foundation
import SwiftyJSON
import Alamofire
import RealmSwift

protocol VkFetchable: class {
    static var path: String { get }
    static var parameters: Parameters { get }
    
    static func parseJSON(json: JSON) -> Self
}
@objcMembers
final class User: Object, VkFetchable{
    enum Properties: String {
        case id
        case author
        case firstName
        case surName
        case imageString
        case photos
    }
    
    static func parseJSON(json: JSON) -> User {
        let user = User(json: json)
        return user
    }
    static var path: String {
        return "/method/friends.get"
    }
    static var parameters: Parameters {
        return [
            "access_token": Session.shared.token,
            "fields": "nickname, domain, sex, bdate, city, country, timezone, photo_50, online",
            "v": "5.80"
        ]
    }
 
    dynamic var id = 0
    dynamic var author = ""
    dynamic var firstName = ""
    dynamic var surName = ""
    dynamic var imageString = ""
 
    var photos = List<VKPhotoAll>()
    
    convenience init(json: JSON, photos: [VKPhotoAll] = []) {
        self.init()
        
        self.id = json["id"].intValue
        self.author = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.firstName = json["first_name"].stringValue
        self.surName = json["last_name"].stringValue
        self.imageString = json["photo_50"].stringValue
        self.photos.append(objectsIn: photos)
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
