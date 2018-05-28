//
//  ChannelVC.swift
//  Chat-App
//
//  Created by Danny Bokati on 12/24/17.
//  Copyright © 2017 Gtech Developeres. All rights reserved.
//

import UIKit

@IBDesignable
class ChannelVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogo.layer.cornerRadius = userLogo.layer.frame.height / 2
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userLogo.image = UIImage(named: UserDataService.instance.avatarName)
            userLogo.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            tableView.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelDataDidChange(_:)), name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannelVC = CreateChannel()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC, animated: true, completion: nil)
        }
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    @objc func userDataDidChange(_ notif: Notification) {
        
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userLogo.image = UIImage(named: UserDataService.instance.avatarName)
            userLogo.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userLogo.image = UIImage(named: "menuProfileIcon")
            userLogo.backgroundColor = UIColor.clear
        }
    }
    
    @objc func channelDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            MessageService.instance.channels.removeAll()
            MessageService.instance.findAllChannels { (success) in
                if success {
                    self.tableView.reloadData()
                } else {
                    print("Reloading Channels Failed")
                }
            }
        } else {
            MessageService.instance.channels.removeAll()
            tableView.reloadData()
        }
    }
    
    
    //MARK: Channel Datasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelCell
        cell.setupCell(channel: MessageService.instance.channels[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SECLECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
}
