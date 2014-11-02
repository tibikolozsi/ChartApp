//
//  ViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 28/09/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework


let kSimpleLineString = "Simple Line"
let kBezierCurveString = "Bezier Curve"

class ViewController: UIViewController, UIScrollViewDelegate, LineChartDataSource{
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var values = Array<Float>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.values = Array<Float>()
        self.lineChartView.dataSource = self
        for i in 1...50 {
            addRandomValueToLine()
        }
        self.lineChartView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var AddButton: UIBarButtonItem!
    @IBAction func addButtonTouched(sender: AnyObject) {
        self.addRandomValueToLine()
        self.lineChartView.reloadData()
    }
    
    @IBOutlet weak var changeLineTypeButton: UIBarButtonItem!
    @IBAction func changeLineTypeButtonTouched(sender: AnyObject) {
        if self.lineChartView.lineType == LineType.LineTypeSimple {
             self.lineChartView.lineType = LineType.LineTypeSpline
            changeLineTypeButton.title = kBezierCurveString
        } else if self.lineChartView.lineType == LineType.LineTypeSpline {
            self.lineChartView.lineType = LineType.LineTypeSimple
            changeLineTypeButton.title = kSimpleLineString
        }
    }
    @IBAction func addNewPointToLine(sender: AnyObject) {
        addRandomValueToLine()
    }
    
    func addRandomValueToLine() {
        let lineChartViewHeight: UInt32 = 4000
        var randomValue: Float = Float(arc4random_uniform(lineChartViewHeight))
        self.values.append(randomValue)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    func lineChartNumberOfData(lineChart: LineChartView) -> Int {
        return self.values.count
    }
    
    func lineChartValueForData(linechart: LineChartView, index: Int) -> Float {
        return self.values[index]
    }
    
    func lineChartTextForData(lineChart: LineChartView, index: Int) -> String {
        return String(format: "%f",self.values[index])
    }

}

