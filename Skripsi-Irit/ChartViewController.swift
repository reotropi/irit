//
//  ChartViewController.swift
//  Skripsi-Irit
//
//  Created by Aida Fitryani on 06/04/18.
//  Copyright © 2018 reyyaa-aps. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

public struct Transaction {
    var transID : Int!
    var itemName : String!
    var category : String!
    var frequency : String!
    var amount : Int!
    var date : Date!
}


class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var transArray = [Transaction()]
    var categoryChoosen = ""
    
    var categories = ["Transportation", "Entertainment", "Food & Beverages", "Sport", "Health", "Accommodation", "Fashion", "Daily Groceries", "Other"]
    var newIndex = [String()]
    var valTemp : [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var valuesOnPie : [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var total = 0.0
    
    override func viewDidLoad() {
        self.pieChart.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        transArray.removeAll()
        pieChart.delegate = self
        loadData()
    }
    
    func loadData(){
        let linkString = "http://skripsi.expensa-app.com/wp-json/thisskripsi/pulltrans/"
        Alamofire.request(linkString, method: .post, parameters: ["token" : token], encoding: JSONEncoding.default).responseJSON { response in
            switch response.result{
            case .success(let val):
                let json = JSON(val)
                if json.arrayValue.count > 0 {
                    for index in 0..<json.arrayValue.count{
                        var transTemp = Transaction()
                        transTemp.transID = json[index]["transID"].intValue
                        transTemp.itemName = json[index]["itemName"].stringValue
                        transTemp.category = json[index]["category"].stringValue
                        transTemp.frequency = json[index]["frequency"].stringValue
                        transTemp.amount = json[index]["amount"].intValue
                        let date = json[index]["date"].stringValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
                        transTemp.date = dateFormatter.date(from: date)
                        self.transArray.append(transTemp)
                    }
                    self.fillCategoryValue()
                    self.setChart(dataPoints: self.categories, values: self.valuesOnPie)
                    self.pieChart.isHidden = false
                }
            case .failure(let err):
                print (err)
            }
        }
    }
    
    func fillCategoryValue(){
        print(transArray.count)
        for j in 0..<transArray.count {
            for i in 0..<categories.count {
                if (categories[i] == transArray[j].category){
                    self.valTemp[i] += Double(transArray[j].amount)
                    total += Double(transArray[j].amount)
                    break
                }
            }
        }
        
        for k in 0..<self.valTemp.count {
            valuesOnPie[k] = valTemp[k]/total*100
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        var entries = [PieChartDataEntry]()
        newIndex.removeAll()
        for i in 0..<dataPoints.count {
            if values[i] != 0.0 {
                let entry = PieChartDataEntry()
                newIndex.append(dataPoints[i])
                entry.y = values[i]
                entry.label = dataPoints[i]
                entries.append(entry)
            }
        }
        let set = PieChartDataSet(values: entries, label: "")
        
        var colors: [UIColor] = []
        /*Random the color for every category part.*/
        for _ in 0..<values.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChart.chartDescription?.text = ""
        pieChart.data = data
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        self.view.addSubview(pieChart)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
            
            let sliceIndex: Int = dataSet.entryIndex( entry: entry)
            categoryChoosen = newIndex[sliceIndex]
            performSegue(withIdentifier: "transListSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! TransactionsViewController
        for index in 0..<transArray.count{
            if (transArray[index].category == categoryChoosen){
                next.transArray.removeAll()
                next.transArray.append(transArray[index])
            }
        }
    }
}
