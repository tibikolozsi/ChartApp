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
    
    var data: Array<SliceData> = Array<SliceData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.dataSource = self
        pieChartView.delegate = self

        data = [SliceData(value: 2.0, text: "Two", color: PSColor(r: 61, g: 147, b: 147, a: 1.0)),
            SliceData(value: 3.0, text: "", color: PSColor(r: 244, g: 129, b: 128, a: 1.0)),
            SliceData(value: 4.0, text: "", color: PSColor(r: 182, g: 208, b: 72, a: 1.0)),
            SliceData(value: 6.0, text: "", color: PSColor(r: 251, g: 136, b: 61, a: 1.0)),
            SliceData(value: 20.0, text: "", color: PSColor(r: 132, g: 193, b: 198, a: 1.0)),
            SliceData(value: 4, text: "", color: PSColor(r: 225, g: 201, b: 171, a: 1.0))]
        
        pieChartView.layer.borderColor = UIColor.blackColor().CGColor
        pieChartView.layer.borderWidth = 2.0
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
