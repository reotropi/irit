//
//  LoginViewController.swift
//  Skripsi-Irit
//
//  Created by Aida Fitryani on 05/04/18.
//  Copyright © 2018 reyyaa-aps. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON

public var token = ""

class LoginViewController: FormViewController {

    var user = ""
    var pass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Enter your login credential.")
        <<< AccountRow(){
            $0.title = "Username"
            $0.tag = "UserRow"
            }.onChange{ row in
                self.user = row.value != nil ? row.value! : ""
            }
        <<< PasswordRow(){
            $0.title = "Password"
            $0.tag = "PasswordRow"
            }.onChange{ row in
                 self.pass = row.value != nil ? row.value! : ""
            }
        <<< ButtonRow(){
            $0.title = "Login"
            $0.tag = "LoginButtonRow"
            }.onCellSelection{ cell, row in
                if self.user != "" && self.pass != "" {
                    self.login()
                }
            }
        }
    
    func login(){
        let params: [String:Any] = [
            "username" : self.user,
            "password" : self.pass
        ]
        let linkString = "http://skripsi.expensa-app.com/wp-json/jwt-auth/v1/token"
        Alamofire.request(linkString, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result{
            case .success(let val):
                let json = JSON(val)
                token = json["token"].stringValue
                UserDefaults.standard.set(token, forKey: "irit_token")
                self.performSegue(withIdentifier: "successLoginSegue", sender: nil)
            case .failure(let err):
                print (err)
            }
        }
    }
}

