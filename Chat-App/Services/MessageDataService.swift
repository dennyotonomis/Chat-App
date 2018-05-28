//
//  MessageDataService.swift
//  Chat-App
//
//  Created by Danny Bokati on 5/23/18.
//  Copyright © 2018 Gtech Developeres. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    var selectedChannel: Channel!
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        ProgressHud.showProgressHUD()
        print(URL_ALL_CHANNELS)
        print(BEARER_HEADER)
        Alamofire.request(URL_ALL_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                print(response)
                guard let data = response.data else {return}
                if let json = try! JSON(data: data).array {
                    for item in json {
                        let id = item["_id"].stringValue
                        let description = item["description"].stringValue
                        let channelName = item["name"].stringValue
                        
                        let channel = Channel(channelName: channelName, channelID: id, channelDescription: description)
                        self.channels.append(channel)
                    }
                }

                ProgressHud.hideProgressHUD()
                completion(true)
            } else {
                ProgressHud.hideProgressHUD()
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func addNewChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        ProgressHud.showProgressHUD()
        
        let body = [
            "name": channelName,
            "description": channelDescription
        ]
        
        Alamofire.request(URL_ADD_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: NORMAL_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                print(response)
                ProgressHud.hideProgressHUD()
                completion(true)
            } else {
                ProgressHud.hideProgressHUD()
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
}
