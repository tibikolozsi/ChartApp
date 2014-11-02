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
    var lineType:LineType = LineType.LineTypeSpline {
        didSet(newType) {
            if let button = self.changeLineTypeButton {
                if newType == LineType.LineTypeSimple {
                    button.title = kSimpleLineString
                } else if newType == LineType.LineTypeSpline {
                    button.title = kBezierCurveString
                }
            }
        }
    }
    
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
    @IBAction func switchChanged(sender: AnyObject) {
        self.lineChartView.bezierCurveIsEnabled = !self.lineChartView.bezierCurveIsEnabled;
        self.lineChartView.setNeedsDisplay()
    }

    @IBOutlet weak var changeLineTypeButton: UIBarButtonItem!
    @IBAction func changeLineTypeButtonTouched(sender: AnyObject) {
        if self.lineType == LineType.LineTypeSimple {
            self.lineType = LineType.LineTypeSpline
        } else if self.lineType == LineType.LineTypeSpline {
            self.lineType = LineType.LineTypeSimple
        }
        self.lineChartView.setNeedsDisplay()
    }
    @IBAction func addNewPointToLine(sender: AnyObject) {
        addRandomValueToLine()
    }
    
    func addRandomValueToLine() {
        let lineChartViewHeight: UInt32 = 4000
//        println(self.lineChartView.frame.height)
        var randomValue: Float = Float(arc4random_uniform(lineChartViewHeight))
//        println("added value: \(randomValue)")
        self.lineChartView.addValueToLine(randomValue)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }

}

