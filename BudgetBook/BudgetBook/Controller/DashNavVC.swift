//
//  DashNavVC.swift
//  BudgetBook
//
//  Created by 张婧莹 on 2019/5/26.
//  Copyright © 2019年 张婧莹. All rights reserved.
//

import UIKit

class DashNavVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "budget")!)
        self.navigationItem.title = "Budget Book"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
