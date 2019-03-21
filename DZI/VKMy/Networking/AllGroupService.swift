//
//  AllGroupService.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.01.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

class AllGroupService {
    let baseUrl = "https://api.vk.com"
    let path = "/method/groups.search"
    var search = ""
    
    public func LoadGroupForecast(searchText: String, completionHandler: (([SearchGroups]?, Error?) -> Void)? = nil ) {
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "q": searchText,
            "v": "5.80"
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completionHandler?(nil, error)
            case .success(let value):
                let json = JSON(value)
                
                let groupNew = json["response"]["items"].arrayValue.map {
                    SearchGroups(json: $0) }
               completionHandler?(groupNew, nil)
           
            }
        }
    }
}
