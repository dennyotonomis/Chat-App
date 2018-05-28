//
//  SocketService.swift
//  Chat-App
//
//  Created by Danny Bokati on 5/24/18.
//  Copyright © 2018 Gtech Developeres. All rights reserved.
//

import UIKit
import SocketIO

let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel (completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channeName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let id = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelName: channeName, channelID: id, channelDescription: channelDescription)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
}
