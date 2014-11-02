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

class ViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...5 {
            addRandomValueToLine()
        }
        self.lineChartView.setNeedsDisplay()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.lineChartView.addValueToLine(randomValue)
        self.lineChartView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }

}

