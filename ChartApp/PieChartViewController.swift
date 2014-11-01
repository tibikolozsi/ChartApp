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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.dataSource = self
        pieChartView.delegate = self
        pieChartView.reloadData()
        
        pieChartView.layer.borderColor = UIColor.blackColor().CGColor
        pieChartView.layer.borderWidth = 2.0
        // Do any additional setup after loading the view.
        
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
        return kNumberOfSlices
    }
    
    func textForSlice(pieChar: PieChartView, index: Int) -> String {
        return String(index)
    }
    
    func valueForSlice(pieChart: PieChartView, index: Int) -> CGFloat {
        return CGFloat(index+1)
    }
    
    func colorForSlice(pieChart: PieChartView, index: Int) -> UIColor {
        var color:UIColor
        let scaledIndex = index % kNumberOfColors
        switch (index) {
            case 0:
                color = PSColor(r: 61, g: 147, b: 147, a: 1.0)
            case 1:
                color = PSColor(r: 244, g: 129, b: 128, a: 1.0)
            case 2:
                            color = PSColor(r: 182, g: 208, b: 72, a: 1.0)
            case 3:
                color = PSColor(r: 251, g: 136, b: 61, a: 1.0)
        case 4:
                        color = PSColor(r: 132, g: 193, b: 198, a: 1.0)
        default:
                        color = PSColor(r: 225, g: 201, b: 171, a: 1.0)
        }
        return color
//        return UIColor.clearColor()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
