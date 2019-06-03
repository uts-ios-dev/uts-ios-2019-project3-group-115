//
//  ViewController.swift
//  BudgetBook
//
//  Created by 张婧莹 on 2019/5/16.
//  Copyright © 2019年 张婧莹. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var History: UITableView!
    var time = ["date","date"]
    var spend = ["No Data", "No Data"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        History.delegate = self
        History.dataSource = self
        
        if Storage.fileExists("data.jason", in: .documents) {
            time = []
            spend = []
            var dataFromFile = Storage.retrieve("data.jason", from: .documents, as: [Expense].self)
            if appDataArr.count != 0 && dataFromFile.count != appDataArr.count {
                dataFromFile = appDataArr
            }
            for obj in dataFromFile {
                time.append(obj.date)
                let newSpend = obj.category + ":" + String(obj.amount)
                spend.append(newSpend)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return time.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = time[indexPath.row]
        cell.detailTextLabel?.text = spend[indexPath.row]
        
        return cell
        
    }
    
    
    
}

