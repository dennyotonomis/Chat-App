//
//  ChatVC.swift
//  Chat-App
//
//  Created by Danny Bokati on 12/24/17.
//  Copyright © 2017 Gtech Developeres. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var MenuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(email: AuthService.instance.userEmail, completion: { (success) in
                MessageService.instance.findAllChannels(completion: { (success) in
                    print("Channels Initialised")
                })
            })
        } else {
            
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
//        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
//        NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelDataDidChange(_:)), name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
        
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            titleLabel.text = "Logged In"
            AuthService.instance.findUserByEmail(email: AuthService.instance.userEmail, completion: { (success) in
                print("User data loaded")
            })
        } else {
            titleLabel.text = "Please Log In"
        }
        
    }
    
    @objc func channelDataDidChange(_ notif: Notification) {
    }
    
    func onLoginGetMessages() {
        
    }
    
    
    
}
