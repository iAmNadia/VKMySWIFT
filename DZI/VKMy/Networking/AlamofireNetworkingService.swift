//
//  AlamofireNetworking.swift
//  VKMy
//
//  Created by NadiaMorozova on 20.12.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkingService {
    
    let baseUrl = "https://api.oauth.vk.com"
    
    static let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    public func sendRequest() {
        Alamofire.request("https://oauth.vk.com/authorize").responseJSON { response in
            
            guard let value = response.value else { return }
            
            print(value)
        }
    }
    
    public func sendRequest(city: String) {
        let path = "/authorize"
        
        let params: Parameters = [
            "client_id" : "6704883",
            "display" : "mobile",
            "redirect_uri" : "https://oauth.vk.com/blank.html"
        ]
        
        AlamofireNetworkingService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            guard let value = response.value else { return }
            print(value)
        }
    }
}
