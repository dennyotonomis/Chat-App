//
//  Authservice.swift
//  Chat-App
//
//  Created by Danny Bokati on 1/26/18.
//  Copyright © 2018 Gtech Developeres. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AuthService{
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var authToke: String {
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
            
        }
        
    }
    var userEmail: String {
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
            
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        ProgressHud.showProgressHUD()
        let lowerCasedEmail = email.lowercased()
       
        
        let body: [String:Any] = [
            "email": lowerCasedEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                ProgressHud.hideProgressHUD()
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
                ProgressHud.hideProgressHUD()
            }
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        ProgressHud.showProgressHUD()
        let lowerCasedEmail = email.lowercased()
       
        
        let body: [String:Any] = [
            "email": lowerCasedEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                print(response)
                guard let data = response.data else {return}
               let json = try? JSON(data: data)
                
               
                
                self.userEmail = json!["user"].stringValue
                self.authToke = json!["token"].stringValue
                print(self.userEmail)
                print(self.authToke)
                
                
                
                self.isLoggedIn = true
                ProgressHud.hideProgressHUD()
                completion(true)
                
                
                
            }else{
                ProgressHud.hideProgressHUD()
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        ProgressHud.showProgressHUD()
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCasedEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
            
        ]
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToke)",
            "Content-Type":"application/json; charset=utf-8" ]
        
        
        print(header)
        print(body)
        Alamofire.request(URL_CREATEUSER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                print(response)
                if let json = response.result.value as? Dictionary<String, Any> {
                    let id = json["_id"] as? String
                    let avatarColor = json["avatarColor"] as? String
                    let avatarName = json["avatarName"] as? String
                    let email = json["email"] as? String
                    let name = json["name"] as? String
                    
                    UserDataService.instance.setUserData(id: id!, color: avatarColor!, avatarName: avatarName!, email: email!, name: name!)
                    print(UserDataService.instance.id)
                    print(UserDataService.instance.email)
                    print(UserDataService.instance.name)
                    
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
    
    func findUserByEmail(email: String, completion: @escaping CompletionHandler) {
        ProgressHud.showProgressHUD()
        let lowerCasedEmail = email.lowercased()
        print(lowerCasedEmail)
        print(email)
        print(AuthService.instance.authToke)
        let header = ["Authorization":"Bearer \(AuthService.instance.authToke)"]
        
        Alamofire.request("\(URL_FIND_USER_BY_EMAIL)/\(lowerCasedEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                print(response)
                if let json = response.result.value as? Dictionary<String, Any> {
                    let id = json["_id"] as? String
                    let avatarColor = json["avatarColor"] as? String
                    let avatarName = json["avatarName"] as? String
                    let email = json["email"] as? String
                    let name = json["name"] as? String
                    
                    UserDataService.instance.setUserData(id: id!, color: avatarColor!, avatarName: avatarName!, email: email!, name: name!)
                    print(UserDataService.instance.id)
                    print(UserDataService.instance.email)
                    print(UserDataService.instance.name)
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
    
    
    
    
    
    
    
    
    
}
