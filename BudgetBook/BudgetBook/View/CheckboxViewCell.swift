//
//  CheckboxViewCell.swift
//  BudgetBook
//
//  Created by 张婧莹 on 2019/5/17.
//  Copyright © 2019年 张婧莹. All rights reserved.
//

import UIKit

class CheckboxViewCell: UITableViewCell {
    @IBOutlet weak var checkboxImage: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var isChecked: Bool!
    
    @objc func here() {
        isChecked = !isChecked
        BudgetInfoTableViewController.categoriesCheckedStatus[categoryLabel.text!] = isChecked
        UserDefaults.standard.set(BudgetInfoTableViewController.categoriesCheckedStatus, forKey: "categoriesCheckedStatus")
        
        if isChecked {
            checkboxImage.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            checkboxImage.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
}
