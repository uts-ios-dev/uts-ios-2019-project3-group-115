//
//  Expense.swift
//  BudgetBook
//
//  Created by 张婧莹 on 2019/5/25.
//  Copyright © 2019年 张婧莹. All rights reserved.
//

import Foundation

struct Expense: Codable {
    var date: String
    var amount: Double
    var category: String
}

var appDataArr: [Expense] = []

