//
//  News.swift
//  VKMy
//
//  Created by NadiaMorozova on 01.02.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class News: Object  {
    
    static var parameters: Parameters = [:]
    
    static func parseJSON(json: JSON) -> News {
        let post = News(json: json)
        return post
    }
    
    static var path: String {
        return "/method/newsfeed.get"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var photoNews: String = ""
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var date: Double = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var contentText: String = ""
    @objc dynamic var commentsCount: String = ""
    @objc dynamic var likesCount: String = ""
    @objc dynamic var repostsCount: String = ""
    @objc dynamic var viewsCount: String = ""
    @objc dynamic var usersLike: Int = 0
    @objc dynamic var comments = 0
    @objc dynamic var viewsWatches: Int = 0
    @objc dynamic var reposts: Int = 0
    @objc dynamic var attachmentType: String = ""
    @objc dynamic var type: String = "post"
    @objc dynamic var marketAs: Int = 0
    
    @objc dynamic var user: User?
    @objc dynamic var group: Group?
    convenience init(json: JSON) {
        self.init()
        self.marketAs = json["marked_as_ads"].intValue
        
        if self.type == "post" {
            if self.marketAs == 0 {
                
            self.attachmentType = json["attachments"][0]["type"].stringValue
            self.type = json["type"].stringValue
            self.sourceId = json["source_id"].intValue
            self.date = json["date"].doubleValue
            self.postId = json["post_id"].intValue
            self.commentsCount = json["comments"]["count"].stringValue
            self.comments = json["comments"]["count"].intValue
            self.likesCount = json["likes"]["count"].stringValue
            self.repostsCount = json["reposts"]["count"].stringValue
            self.viewsCount = json["views"]["count"].stringValue
            self.viewsWatches = json["views"]["count"].intValue
            self.usersLike = json["likes"]["user_likes"].intValue
            self.id = json["id"].intValue
            self.reposts = json["reposts"]["count"].intValue
            self.photoNews = json["attachments"][0]["photo"]["sizes"][6]["url"].stringValue
            self.contentText = json["text"].stringValue
                
                if self.attachmentType == "doc" {
                    self.photoNews = json["attachments"][0]["doc"]["preview"]["photo"]["sizes"][2]["src"].stringValue
                }
                if self.attachmentType == "video" {
                    
                    self.photoNews = json["attachments"][0]["video"]["photo_1280"].stringValue
                }
                if self.attachmentType == "link" {
                    self.photoNews = json["attachments"][0]["link"]["photo"]["sizes"][3]["url"].stringValue
                    self.contentText = json["attachments"][0]["link"]["title"].stringValue
                }
                if self.marketAs != 0 {
                    self.photoNews = json["copy_history"][0]["attachments"][0]["photo"]["sizes"][6]["url"].stringValue
                    self.contentText = json["copy_history"][0]["text"].stringValue
                }
            }
        }
    }
}
