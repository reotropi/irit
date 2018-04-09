//
//  CheckLoginViewController.swift
//  Skripsi-Irit
//
//  Created by Aida Fitryani on 05/04/18.
//  Copyright © 2018 reyyaa-aps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.object(forKey: "irit_token") != nil) {
            token = UserDefaults.standard.object(forKey: "irit_token") as! String

            let header : HTTPHeaders = ["Authorization" : "Bearer \(token)"]
            let linkString = "http://skripsi.expensa-app.com/wp-json/jwt-auth/v1/token/validate"
            Alamofire.request(linkString, method: .post, headers: header).responseJSON { response in
                let json = JSON(response.result.value!)
                if (json["data"]["status"].intValue == 200) {
                    self.performSegue(withIdentifier: "haveTokenSegue", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "noTokenSegue", sender: nil)
                }
            }
        }
        else {
            self.performSegue(withIdentifier: "noTokenSegue", sender: nil)
        }
    }
}
