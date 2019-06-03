//
//  CustomNavTableVC.swift
//  BudgetBook
//
//  Created by 张婧莹 on 2019/5/16.
//  Copyright © 2019年 张婧莹. All rights reserved.
//

import UIKit

class CustomNavTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CustomNavVC.manualAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(CustomNavVC.cameraAdd))
        
        self.navigationItem.leftBarButtonItem?.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @objc func manualAdd() {
        let manualEntryVC = storyboard!.instantiateViewController(withIdentifier: "ManualEntryVC") as! ManualEntryVC
        self.present(manualEntryVC, animated: true)
    }
    
    @objc func cameraAdd() {
        // TO DO
    }
}
