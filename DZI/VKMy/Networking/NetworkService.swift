//
//  NetworkService.swift
//  VKMy
//
//  Created by NadiaMorozova on 20.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Alamofire
import WebKit
import UIKit
import SwiftyJSON

class NetworkService {
    
     
    let baseUrl = "https://api.vk.com"
    static func urlForIcon(_ icon: String) -> URL? {
        return URL(string: icon)
    }
    
    func fetch<Element: VkFetchable>(completion: (([Element]?, Error?) -> Void)? = nil){
        let path = Element.path
        let params = Element.parameters
        Alamofire.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
            case .success(let value):
                let json = JSON(value)
                let elements: [Element] = json["response"]["items"].arrayValue.map
                { Element.parseJSON(json: $0) }
                completion?(elements, nil)
            }
        }
    }
    public func authorizeRequest() -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6704883"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.80"),
            URLQueryItem(name: "state", value: "123456")
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
    public func sendRequest() {
        _ = URL(string: "https://api.vk.com/method/users.get?user_id=6704883&v=5.80")
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value:"6704883"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "v", value: "5.80")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            print(json!)
        }
        
        task.resume()
    }

    func testPostRequest() {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        urlComponents.path = "/posts"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "title", value: "foo"),
            URLQueryItem(name: "body", value: "bar"),
            URLQueryItem(name: "userId", value: "1")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            print(json!)
        }
        
        task.resume()
    }

func PhotoIdAlamofire(completion: (([VKPhotoAll]?, Error?) -> Void)? = nil ){
    
    let baseUrl = "https://api.vk.com"
    let path = "/method/photos.getAll"
    let params: Parameters = [
        "access_token": Session.shared.token,
        "owner_id": Session.shared.friendId,
        "photo_sizes": "0",
        "no_service_albums": "0",
        "v": "5.80",
        "photo_size": "1",
        "count": "200"
    ]
    
    Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
        switch response.result {
        case .failure(let error):
            completion?(nil, error)
            print(error.localizedDescription)
        case .success(let value):
            let json = JSON(value)
            let friends = json["response"]["items"].arrayValue.map { VKPhotoAll( json: $0) }
            completion?(friends, nil)
            print(value)
        }
    }
}
    func PhotoIdHaHaAlamofire(searchText: String, completion: (([SearchGroups]?, Error?) -> Void)? = nil ){
        
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.search"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "q": searchText, // .lowercased(),//"Swift",
            "v": "5.80"
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion?(nil, error)
                print(error.localizedDescription)
            case .success(let value):
                let json = JSON(value)
                let group = json["response"]["items"].arrayValue.map { SearchGroups( json: $0) }
                completion?(group, nil)
//                print(value)
            }
        }
    }
    
        func SearchAlamofire(searchText: String, completion: @escaping ([SearchGroups]) -> Void) {// completion: (([SearchGroups]?, Error?) -> Void)? = nil ) {
   
            let baseUrl = "https://api.vk.com"
            let path = "/method/groups.search"
            let params: Parameters = [
                "access_token": Session.shared.token,
                "q": searchText,//.lowercased(),//"Swift",
                "v": "5.80"
            ]

            Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let value):
                    print(value)
                }
            }
        }
    enum joinAndLeaveGroup: String {
        case joinGroup = "/method/groups.join"
        case leaveGroup = "/method/groups.leave"
    }
    
    func joinAndLeaveAnyGroup(groupId: Int, action: joinAndLeaveGroup) {
        var path = ""
        
        if action == .joinGroup {
            path = joinAndLeaveGroup.joinGroup.rawValue
        } else {
            path = joinAndLeaveGroup.leaveGroup.rawValue
        }
        
        
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": Session.shared.token,
            "v": "5.80"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            
        }
    }
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
            parameters).responseJSON(completionHandler: {
                response in
                switch response.result {
                case .failure(let error):
                    completion?(nil, error)
                case .success(let value):
                    let json = JSON(value)
                    let likes = json["response"]["likes"].intValue
                    completion?(likes, nil)
                }
            })
    }
//   public func roundViews (count: Int) -> String {
//        switch count {
//        case _ where count < 1000: return String(count)
//        case _ where count == 1000: return "1K"
//        case _ where count > 1000 && count < 1099 : return String((count)[0]) + "К"
//        case _ where count > 1099 && count < 9999 : return String((count)[0]) + "," + String((count)[1]) + "К"
//        case _ where count > 9999 && count < 99999: return String(String(count)[0]) + "" + String(String(count)[1]) + "К"
//        case _ where count > 99999 && count < 999999: return String(String(count)[0]) + "" + String(String(count)[1]) + "" + String(String(count)[2]) + "К"
//        case _ where count > 999999: return String(String(count)[0]) + "М"
//        default:
//            return String(count)
//        }
//    }
//}

}
extension UIImageView{
    func downloadImg(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
} 
