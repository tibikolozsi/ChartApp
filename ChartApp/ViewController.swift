//
//  ViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 28/09/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework

class ViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...10 {
            addRandomValueToLine()
        }
        self.lineChartView.setNeedsDisplay()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func switchChanged(sender: AnyObject) {
        self.lineChartView.bezierCurveIsEnabled = !self.lineChartView.bezierCurveIsEnabled;
        self.lineChartView.setNeedsDisplay()
    }

    @IBAction func addNewPointToLine(sender: AnyObject) {
        addRandomValueToLine()
    }
    
    func addRandomValueToLine() {
        let lineChartViewHeight: UInt32 = UInt32(self.lineChartView.frame.height)
        println(self.lineChartView.frame.height)
        var randomValue: CGFloat = CGFloat(arc4random_uniform(lineChartViewHeight))
        println("added value: \(randomValue)")
        self.lineChartView.addValueToLine(randomValue)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }

}

