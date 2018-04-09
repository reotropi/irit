//
//  AddNewTransViewController.swift
//  Skripsi-Irit
//
//  Created by Aida Fitryani on 05/04/18.
//  Copyright © 2018 reyyaa-aps. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON

class AddNewTransViewController: FormViewController {

    var transID = -1
    var itemName = ""
    var category = ""
    var frequency = ""
    var amount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Your Transaction Item")
        <<< TextRow() {
            $0.title = "Item Name"
            $0.placeholder = "Enter item name here"
            if self.itemName != "" {
                $0.value = self.itemName
            }
            }.onChange{ row in
                self.itemName = row.value != nil ? row.value! : ""
            }
            
        <<< AlertRow<String>() {
            $0.title = "Category"
            $0.options = ["Transportation", "Entertainment", "Food & Beverages", "Sport", "Health", "Accommodation", "Fashion", "Daily Groceries", "Other"]
            if self.category != "" {
                $0.value = self.category
            }
            }.onChange{ row in
                self.category = row.value != nil ? row.value! : ""
            }
            
        <<< AlertRow<String>() {
            $0.title = "Frequency"
            $0.options = ["Three times a day","Twice a day","Every day","Every week day","Twice a week","Every Week","Twice a month","Every month","Sometimes","Only once"]
            if self.frequency != "" {
                $0.value = self.frequency
            }
            }.onChange{ row in
                self.frequency = row.value != nil ? row.value! : ""
            }
            
        <<< DecimalRow() {
            $0.title = "Amount"
            $0.tag = "amountRow"
            if self.amount != 0 {
                $0.value = Double(self.amount)
            }
            }.onChange{ row in
                self.amount = row.value != nil ? Int(row.value!) : Int(0.0)
            }
        
        <<< ButtonRow() {
            $0.title = "Add New Transaction"
            }.onCellSelection{ cell, row in
                if self.itemName != "" && self.category != "" && self.frequency != "" && self.amount != 0 {
                    self.addTrans()
                }
            }
        }
    
    func addTrans(){
        if (transID == -1){
            let params: [String:Any] = [
                "itemName" : self.itemName,
                "category" : self.category,
                "frequency" : self.frequency,
                "amount" : self.amount,
                "token" : token
            ]
            let linkString = "http://skripsi.expensa-app.com/wp-json/thisskripsi/addtrans/"
            Alamofire.request(linkString, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result{
                    case .success(let val):
                        if JSON(val).stringValue == "success." {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let err):
                        print (err)
                }
            }
        }
        else {
            let params: [String:Any] = [
                "itemName" : self.itemName,
                "category" : self.category,
                "frequency" : self.frequency,
                "amount" : self.amount,
                "transID" : self.transID,
                "token" : token
            ]
            let linkString = "http://skripsi.expensa-app.com/wp-json/thisskripsi/edittrans/"
            Alamofire.request(linkString, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result{
                    case .success(let val):
                        if JSON(val).stringValue == "success." {
                            self.transID = -1
                            self.itemName = ""
                            self.category = ""
                            self.frequency = ""
                            self.amount = 0
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let err):
                        print (err)
                }
            }
        }
    }
}
