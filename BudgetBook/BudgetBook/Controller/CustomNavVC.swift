//
//  CustomNavVC.swift
//  BudgetBook
//
//  Created by 张婧莹 on 2019/5/16.
//  Copyright © 2019年 张婧莹. All rights reserved.
//

import UIKit
import Charts

class CustomNavVC: UIViewController, ChartViewDelegate {
    
    let kWidth = UIScreen.main.bounds.size.width
    let kHeight = UIScreen.main.bounds.size.height
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CustomNavVC.manualAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(CustomNavVC.cameraAdd))
        
        self.navigationItem.leftBarButtonItem?.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // ------------------------Add Chart to show Spending Line of The Month
        // read data from file
        var dataFromFile = [Expense]()
        if Storage.fileExists("data.jason", in: .documents) {
            dataFromFile = Storage.retrieve("data.jason", from: .documents, as: [Expense].self)
        }
        if appDataArr.count != 0 && dataFromFile.count != appDataArr.count {
            dataFromFile = appDataArr
        }
        print("-------------------Stored Data----------------\(dataFromFile)")
        print("-------------------Global Data----------------\(appDataArr)")
        // set the View of the Bar Chart
        let spendingLine = BarChartView.init(frame: CGRect(x: 0.1 * kWidth, y: 0.16 * kHeight, width: 0.8 * kWidth, height: 0.32 * kHeight))
        // Description of the Chart
        spendingLine.chartDescription.font = UIFont.systemFont(ofSize: 13.0)
        spendingLine.chartDescription.textColor = UIColor.black
        spendingLine.noDataText = "No data"
        
        spendingLine.delegate = self;
        spendingLine.backgroundColor = UIColor.init(red: 230/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1.0);
        spendingLine.doubleTapToZoomEnabled = false;
        spendingLine.scaleXEnabled = false;
        spendingLine.scaleYEnabled = false;
        spendingLine.chartDescription.text = "";
        
        spendingLine.noDataText = "no data";
        spendingLine.noDataTextColor = UIColor.gray;
        spendingLine.noDataFont = UIFont.boldSystemFont(ofSize: 14);
        
        //y Axis
        spendingLine.rightAxis.enabled = false;
        let leftAxis = spendingLine.leftAxis;
        leftAxis.labelCount = 10;
        leftAxis.forceLabelsEnabled = false;
        leftAxis.axisLineColor = UIColor.black;
        leftAxis.labelTextColor = UIColor.black;
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10);
        leftAxis.labelPosition = .outsideChart;
        leftAxis.gridColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0);
        leftAxis.gridAntialiasEnabled = false
        leftAxis.axisMaximum = 999.00
        leftAxis.axisMinimum = 0.00
        leftAxis.labelCount = 11
        leftAxis.drawZeroLineEnabled = true
        
        //x Axis
        let xAxis = spendingLine.xAxis;
        xAxis.granularityEnabled = true;
        xAxis.labelTextColor = UIColor.black;
        xAxis.labelFont = UIFont.systemFont(ofSize: 10.0);
        xAxis.labelPosition = .bottom;
        xAxis.gridColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0);
        xAxis.axisLineColor = UIColor.black;
        xAxis.axisMinimum = 1.0;
        xAxis.axisMaximum = 30.0;
        xAxis.labelCount = 6;
        
        
        
        // set the data for Line Chart
        // some calculates
        var XdataStr = [String]()
        if dataFromFile.count != 0 {
            for obj in dataFromFile {
                let dataStr = obj.date.split(separator: "/")
                let str = String(dataStr.last!)
                XdataStr.append(str)
            }
        }
        var XdataArray = [String]()
        for obj in XdataStr {
            if !XdataArray.contains(obj) {
                XdataArray.append(obj)
            }
        }
        var Ydata = [Double]()
        for i in 1...31 {
            var temp = 0.0
            for j in 0...XdataArray.count - 1 {
                if Int(XdataArray[j]) == i {
                    temp = temp + dataFromFile[j].amount
                }
                if j == XdataArray.count - 1{
                    Ydata.append(temp)
                }
            }
        }
        var YdataArray = [Double]()
        for obj in Ydata {
            if !YdataArray.contains(obj) {
                YdataArray.append(obj)
            }
        }
        YdataArray.removeFirst()
        // set the data
        var lineChartEntry = [ChartDataEntry]()
        for i in 0...XdataArray.count - 1 {
            let value = ChartDataEntry(x: Double(XdataArray[i])!, y: YdataArray[i])
//            let value = ChartDataEntry(x: Double(i), y: YdataArray[i])
            lineChartEntry.append(value)
            print("------------------This is an Entry-----------------\(value)")
        }
        print("------------------Line XAxis Data--------------------- \(XdataArray)")
        print("------------------Line YAxis Data--------------------- \(YdataArray)")
        let dataSet = LineChartDataSet(values: lineChartEntry, label: "Spending per Day")
        dataSet.colors = [UIColor.red]
        dataSet.setColor(UIColor.red)
        dataSet.lineWidth = 1.0
        let data = LineChartData.init(dataSets: [dataSet])
        spendingLine.data = data
        
        self.view.addSubview(spendingLine)
        
        
        
        // ----------------------- Add Pie Chart to Show Spending by Categories
        let spendingPie = PieChartView.init(frame: CGRect(x: 0.1 * kWidth, y: 0.5 * kHeight, width: 0.8 * kWidth, height: 0.35 * kHeight))
        // set the View of the Pie Chart
        spendingPie.backgroundColor = UIColor.init(red: 230/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1.0)
        spendingPie.setExtraOffsets(left: 10, top: 10, right: 20, bottom: 30)
        spendingPie.chartDescription.text = "Categorized"
        spendingPie.chartDescription.font = UIFont.systemFont(ofSize: 12.0)
        spendingPie.chartDescription.textColor = UIColor.black
        
        spendingPie.usePercentValuesEnabled = false
        spendingPie.dragDecelerationEnabled = false
        spendingPie.drawEntryLabelsEnabled = true
        spendingPie.entryLabelFont = UIFont.systemFont(ofSize: 10)
        spendingPie.entryLabelColor = UIColor.white
        spendingPie.drawSlicesUnderHoleEnabled = true
        
        
        spendingPie.drawHoleEnabled = true// empty pie
        spendingPie.holeRadiusPercent = 0.382
        spendingPie.holeColor = UIColor.white//the centre color is white
        spendingPie.transparentCircleRadiusPercent = 0.5
        
        spendingPie.drawCenterTextEnabled = true
        spendingPie.centerText = "Pie"
        
        //legend settings
        spendingPie.legend.maxSizePercent = 1
        spendingPie.legend.form = .circle
        spendingPie.legend.formSize = 8
        spendingPie.legend.formToTextSpace = 4
        spendingPie.legend.font = UIFont.systemFont(ofSize: 8)
        spendingPie.legend.textColor = UIColor.gray
        spendingPie.legend.horizontalAlignment = .center
        spendingPie.legend.verticalAlignment = .top
        
        //set pie chart data
        // do some calculate "Transport", "Groceries", "Coffee", "Alcohol", "GoingOut", "PhoneBill", "Shopping", "Miscellaneous"
        var pieDic : Dictionary<String, Array<Double>> = ["Transport": [0.0], "Groceries": [0.0], "Coffee": [0.0], "Alcohol": [0.0], "GoingOut": [0.0], "PhoneBill": [0.0], "Shopping": [0.0], "Miscellaneous": [0.0]]
        for obj in dataFromFile {
            switch obj.category {
                case "Transport":
                    var tempArr = pieDic["Transport"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "Transport")
                    continue
                case "Groceries":
                    var tempArr = pieDic["Groceries"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "Groceries")
                    continue
                case "Coffee":
                    var tempArr = pieDic["Coffee"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "Coffee")
                    continue
                case "Alcohol":
                    var tempArr = pieDic["Alcohol"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "Alcohol")
                    continue
                case "GoingOut":
                    var tempArr = pieDic["GoingOut"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "GoingOut")
                    continue
                case "PhoneBill":
                    var tempArr = pieDic["PhoneBill"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "PhoneBill")
                    continue
                case "Shopping":
                    var tempArr = pieDic["Shopping"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "Shopping")
                    continue
                case "Miscellaneous":
                    var tempArr = pieDic["Miscellaneous"]
                    tempArr?.append(obj.amount)
                    pieDic.updateValue(tempArr!, forKey: "Miscellaneous")
                    continue
                default:
                    continue
            }
        }
        var pieDataArr = [Double]()
        var pieLabelTitles = [String]()
        
        for obj in pieDic.keys {
            let tempVal = pieDic[obj]?.reduce(0.0, +)
            pieDataArr.append(tempVal!)
            pieLabelTitles.append(obj)
        }
        print("-----------------------Pie Value----------------------\(pieDataArr)")
        print("-----------------------Pie Label----------------------\(pieLabelTitles)")
        
        var yVals = [PieChartDataEntry]()
        for i in 0...pieDataArr.count - 1 {
            let entry = PieChartDataEntry(value: pieDataArr[i], label: pieLabelTitles[i])
            yVals.append(entry)
        }
        let pieDataSet = PieChartDataSet.init(values: yVals, label: "");
        pieDataSet.colors = [UIColor.red, UIColor.yellow, UIColor.blue, UIColor.orange, UIColor.green, UIColor.purple, UIColor.magenta, UIColor.gray]
        // position of label and data
        pieDataSet.xValuePosition = .insideSlice
        pieDataSet.yValuePosition = .outsideSlice
        pieDataSet.sliceSpace = 1
        pieDataSet.selectionShift = 6.66
        
        pieDataSet.valueLinePart1OffsetPercentage = 0.8
        pieDataSet.valueLinePart1Length = 0.8
        pieDataSet.valueLinePart2Length = 0.4
        pieDataSet.valueLineWidth = 1
        pieDataSet.valueLineColor = UIColor.brown
        
        let pieData = PieChartData.init(dataSets: [pieDataSet]);
        pieData.setValueFont(UIFont.systemFont(ofSize: 10.0));
        pieData.setValueTextColor(UIColor.lightGray);
        spendingPie.data = pieData;
        
        
        self.view.addSubview(spendingPie)
    }
    
    @objc func manualAdd() {
        let manualEntryVC = storyboard!.instantiateViewController(withIdentifier: "ManualEntryVC") as! ManualEntryVC
        self.present(manualEntryVC, animated: true)
    }
    
    @objc func cameraAdd() {
        
    }
    
    

}
