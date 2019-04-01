//
//  NewsService.swift
//  VKMy
//
//  Created by NadiaMorozova on 11.02.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import RealmSwift

class NewsService {

    let path = "/method/newsfeed.get"
    let baseUrl = "https://api.vk.com"
    
    public func getPosts(completion: (([News]?, [User]?,[Group]?, Error?) -> Void)? = nil) {
        let methodName = "/method/newsfeed.get"
        let url = baseUrl + methodName
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.80",
            "filters": "post",
            "fields": "first_name,last_name,name,deactivated,is_closed,is_friend",
            "start_time": String(format:"%d", NSDate().timeIntervalSince1970 - 30*24*60*60),
            "return_banned": 0
        ]
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON(queue: DispatchQueue.global())  {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posts = json["response"]["items"].arrayValue.map { News(json: $0) }
                let profiles = json["response"]["profiles"].arrayValue.map { User(json: $0) }
                let groups = json["response"]["groups"].arrayValue.map { Group(json: $0) }
                DispatchQueue.main.async {
                    completion?(posts, profiles, groups, nil)}
            case .failure(let error):
                 DispatchQueue.main.async {
                completion?(nil, nil, nil, error)
                }
            }
        }
    }
    func loadNews(completion: @escaping ([News],[User],[Group]) -> Void) {
        let parameters: Parameters = [
            
            "access_token": Session.shared.token,
            "count": "50",
            "filters": "post", // , photo, photo_tag, wall_photo, friend, note, audio, video",
            "source_ids": "friends, groups",
            "v": "5.80"
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.value else {
                completion([],[],[])
                return
            }
            let json = try! JSON(data: data)
            let news: [News] = json["response"]["items"].array?.map {
                News(json: $0["photos"]["items"]["sizes"]["url"].array!.first!)
                } ?? []
            let profiles: [User] = json["response"]["profiles"].array?.map {
                User(json: $0)
                } ?? []
            let group: [Group] = json["response"]["groups"].array?.map {
                Group(json: $0)
                } ?? []
            // completion(news, profiles, group)
            DispatchQueue.main.async {
                print(news, profiles, group)
                completion(news, profiles, group)
            }
        }
    }
    private let queueNetworking = DispatchQueue(label: "ru.vkmy.networkservice", qos: .utility, attributes: [.concurrent])
    
    enum likeAction {
        case add
        case delete
    }
    
    func pushLikeRequest(action: likeAction, ownerId: Int, itemId: Int, itemType: String, completion: ((Int?, Error?) -> Void)? = nil) {
        
        let path: String
        switch action {
        case .add:
            path = baseUrl + "/method/likes.add"
        case .delete:
            path = baseUrl + "/method/likes.delete"
        }
        let parameters: Parameters = [
            "type": itemType,
            "owner_id": ownerId,
            "item_id": itemId,
            "access_token": Session.shared.token,
            "version": "5.92"
        ]
        Alamofire.request(path, method: .get, parameters:
            parameters).responseJSON (queue: DispatchQueue.global(), completionHandler: {
        //(queue: queueNetworking, completionHandler: {
                response in
                switch response.result {
                case .failure(let error):
                       DispatchQueue.main.async {
                    completion?(nil, error)}
                case .success(let value):
                    let json = JSON(value)
                    let likes = json["response"]["likes"].intValue
                       DispatchQueue.main.async {
                    completion?(likes, nil)
                    }
                }
            })
    }
}

