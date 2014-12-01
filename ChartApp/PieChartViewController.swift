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
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var pieChartLegend: PieChartLegendView!
    var data: Array<SliceData> = Array<SliceData>()
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
//        data = [SliceData(value: 2.0, text: "Humidity", color: PSColor(r: 61, g: 147, b: 147, a: 1.0)),
//            SliceData(value: 3.0, text: "Pressure", color: PSColor(r: 244, g: 129, b: 128, a: 1.0)),
//            SliceData(value: 4.0, text: "Color", color: PSColor(r: 182, g: 208, b: 72, a: 1.0)),
//            SliceData(value: 6.0, text: "Height", color: PSColor(r: 251, g: 136, b: 61, a: 1.0)),
//            SliceData(value: 20.0, text: "Weight", color: PSColor(r: 132, g: 193, b: 198, a: 1.0)),
//            SliceData(value: 4, text: "Width", color: PSColor(r: 225, g: 201, b: 171, a: 1.0))]
                data = [SliceData(value: 75.0, text: "Humidity", color: UIColor.clearColor()),
                    SliceData(value: 25.0, text: "Pressure", color: PSColor(r: 244, g: 129, b: 128, a: 1.0))]
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
