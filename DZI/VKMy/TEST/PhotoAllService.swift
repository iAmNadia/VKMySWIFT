//
//  VKService.swift
//  VKMy
//
//  Created by NadiaMorozova on 24.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PhotoAllService {
    
    private let baseUrl = "https://api.oauth.vk.com"
    private let path = "/method/photos.getAll"
    
    public func vkForecast(for city: String, completionHandler: (([VKPhotoAll]?, Error?) -> Void)? = nil ) {
        
        let params: Parameters = [
            
            "client_id" : "6704883",
            "display" : "mobile",
            "owner_id": Session.shared.friendId,
            "extended": "1",
            "access_token": Session.shared.token
            
        ]
        
        AlamofireNetworkingService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completionHandler?(nil, error)
            case .success(let value):
                let json = JSON(value)
                let friends = json["response"]["items"]["sizes"].arrayValue.map { VKPhotoAll(json: $0) }
                completionHandler?(friends, nil)
                print(friends)
            }
            guard let value = response.value else { return }
            print(value)
        }
    }
    static func urlForIcon(_ url: String) -> URL? {
        
    // return URL(string: "https://pp.userapi.com/\(url).jpg")
      return URL(string:  "https://pp.userapi.com/c638629/v638629852/2afba/o-dvykjSIB4.jpg")
    }
}
