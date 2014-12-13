//
//  PieChartViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 27/10/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework

let kNumberOfSlices = 6;
let kNumberOfColors = 3;

class PieChartViewController: UIViewController, PieChartDataSource, PieChartDelegate {
    
    @IBAction func segmentedControlValueChanged(sender: AnyObject) {
        if let segmented = sender as? UISegmentedControl {
            if segmented.selectedSegmentIndex == 0 {
                self.data = tabletData;
            } else {
                self.data = iosAndroidData;
            }
            self.pieChartView.reloadData()
        }
    }
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var pieChartLegend: PieChartLegendView!
    var data: Array<SliceData> = Array<SliceData>()
    var tabletData: Array<SliceData> = Array<SliceData>()
    var iosAndroidData: Array<SliceData> = Array<SliceData>()
    @IBAction func addDataButtonTouched(sender: AnyObject) {
        data.append(SliceData(value: 5.0, text: "", color: UIColor.redColor()))
        self.pieChartView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pieChartView.dataSource = self
        self.pieChartView.delegate = self
        self.pieChartView.showLabel = true
        self.pieChartLegend.dataSource = self.pieChartView
        self.pieChartLegend.delegate = self.pieChartView
        self.pieChartView.legend = self.pieChartLegend
        self.tabletData = [SliceData(value: 33.0, text: "Notebooks", color: PSColor(r: 61, g: 147, b: 147, a: 1.0)),
            SliceData(value: 17.0, text: "Desktops", color: PSColor(r: 244, g: 129, b: 128, a: 1.0)),
            SliceData(value: 50.0, text: "Tablet PCs", color: PSColor(r: 182, g: 208, b: 72, a: 1.0))]
        self.iosAndroidData = [SliceData(value: 45.61, text: "iOS", color: PSColor(r: 61, g: 147, b: 147, a: 1.0)),
            SliceData(value: 43.75, text: "Android", color: PSColor(r: 244, g: 129, b: 128, a: 1.0)),
            SliceData(value: 10.64, text: "Other", color: PSColor(r: 182, g: 208, b: 72, a: 1.0))]
        self.data = self.tabletData
        
//                data = [SliceData(value: 75.0, text: "Humidity", color: UIColor.clearColor()),
//                    SliceData(value: 25.0, text: "Pressure", color: PSColor(r: 244, g: 129, b: 128, a: 1.0))]
        self.pieChartLegend.layer.borderColor = UIColor.blackColor().CGColor
        self.pieChartLegend.layer.borderWidth = 2.0
        self.pieChartLegend.layer.cornerRadius = 12.0
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        pieChartView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pieChartDidDeselectSlice(index: Int) {
        
    }
    
    func pieChartDidSelectSlice(index: Int) {
        
    }
    
    func pieChartWillDeselectSlice(index: Int) {
        
    }
    
    func pieChartWillSelectSlice(index: Int) {
        
    }
    
    func numberOfSlicesInPieChart(pieChart: PieChartView) -> Int {
        return data.count
    }
    
    func textForSlice(pieChar: PieChartView, index: Int) -> String {
        return data[index].text
    }
    
    func valueForSlice(pieChart: PieChartView, index: Int) -> CGFloat {
        return data[index].value
    }
    
    func colorForSlice(pieChart: PieChartView, index: Int) -> UIColor {
        return data[index].color
    }

    
}
