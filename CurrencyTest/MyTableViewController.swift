//
//  MyTableViewController.swift
//  CurrencyTest
//
//  Created by Maxim Pakhotin on 02.07.2018.
//  Copyright © 2018 Maxim Pakhotin. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {
    var curList = [Dictionary<String,String>]()
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeList()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval.init(15), target: self, selector: #selector(makeList), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.curList.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell", for: indexPath) as! MyTableViewCell
        let currency = curList[indexPath.row]
        cell.name.text = currency["name"]
        cell.volume.text = currency["volume"]
        cell.amount.text = currency["amount"]
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        if (cell.contentView.layer.sublayers![0].cornerRadius != 10){
        let cLayer = CALayer()
        cLayer.frame = cell.bounds.insetBy(dx: 2, dy: 2)
        cLayer.backgroundColor = UIColor.white.withAlphaComponent(0.8).cgColor
        cLayer.cornerRadius = 10
        cell.contentView.layer.insertSublayer(cLayer, at: 0)
        }
    }
 
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        makeRefreshView()
        makeList()
    }
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    @objc func makeList()  {
        let url = URL.init(string: "https://phisix-api3.appspot.com/stocks.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if data != nil && error == nil {
                do {
                    guard let data = data else {
                        throw JSONError.NoData
                    }
                    guard let djson = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any> else {
                        throw JSONError.ConversionFailed
                    }
                    guard let array = djson["stock"] as? Array<Dictionary<String,Any>> else {
                        throw JSONError.ConversionFailed
                    }
                    for currency in array {
                        var curDict = Dictionary<String,String>()
                        for (key, value) in currency {
                            switch key {
                            case "name":
                                if let val = value as? String{
                                curDict[key] = val
                                }
                            case "price":
                                if let val = value as? Dictionary<String,Any>{
                                    let amount = val["amount"] as! Double
                                    curDict["amount"] = String.init(format: "%.2f", amount)
                                }
                            case "volume":
                                if let val = value as? Int{
                                    curDict[key] = String(val)
                                }
                            default:
                                break
                            }
                        }
                        self.curList.append(curDict)
                    }
                    
                    
                } catch let error as JSONError {
                   print( error.rawValue )
                } catch let error as NSError {
                    print( error.debugDescription )
                }
                DispatchQueue.main.async {
                     self.tableView.reloadData()
                    self.navigationController?.view.viewWithTag(10)?.removeFromSuperview()
                }
               
                
            }
        }.resume()
    }
    func makeRefreshView() {
        let refreshView = UIView.init(frame: self.view.frame)
        refreshView.tag = 10
        refreshView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0, blue: 0.4549019608, alpha: 1).withAlphaComponent(0.6)
        let refreshIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        refreshIndicator.center = refreshView.center
        refreshIndicator.startAnimating()
        refreshView.addSubview(refreshIndicator)
        self.navigationController?.view.addSubview(refreshView)
        
    }
  

}
