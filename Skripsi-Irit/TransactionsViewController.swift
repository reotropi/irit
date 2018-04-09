//
//  TransactionsViewController.swift
//  Skripsi-Irit
//
//  Created by Aida Fitryani on 05/04/18.
//  Copyright © 2018 reyyaa-aps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var indexToEdit = -1
    
    @IBOutlet weak var transactionTableView: UITableView!
    
    var transArray =  [Transaction()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        transactionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transCell", for: indexPath)
        if (transArray.count)>0{
            cell.textLabel?.text = transArray[indexPath.row].itemName + " -> " + String(transArray[indexPath.row].amount)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        let edit = UITableViewRowAction(style: .normal, title: "Edit"){ action, index in
            self.indexToEdit = indexPath.row
            self.performSegue(withIdentifier: "addTransactionSegue", sender: nil)
            self.indexToEdit = -1
        }
        
        edit.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete"){ action, index in
     
        let linkString =  "http://skripsi.expensa-app.com/wp-json/thisskripsi/deletetrans/"
                
            Alamofire.request(linkString, method: .post, parameters: [ "token" : token, "transID" : self.transArray[indexPath.row].transID ]).responseJSON { response in
                switch response.result{
                case .success(let val):
                    print(val)
                case .failure(let err):
                    print(err)
                }
                self.transArray.remove(at: indexPath.row)
                self.transactionTableView.reloadData()
            }
        }
        delete.backgroundColor = UIColor.red
        return [edit, delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if indexToEdit != -1 {
            let next = segue.destination as! AddNewTransViewController
            next.transID = transArray[indexToEdit].transID
            next.itemName = transArray[indexToEdit].itemName
            next.category = transArray[indexToEdit].category
            next.frequency = transArray[indexToEdit].frequency
            next.amount = transArray[indexToEdit].amount
        }
    }
}
