//
//  ViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 28/09/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework

class ViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()


        
        for i in 1...5 {
            addRandomValueToLine()
        }
        self.lineChartView.setNeedsDisplay()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        println(self.scrollView.contentSize)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() 
        self.scrollView.contentSize = self.lineChartView.bounds.size
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 10
        self.scrollView.zoomScale = 1.6
        self.scrollView.userInteractionEnabled = true
        self.scrollView.scrollEnabled = true
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
        let lineChartViewHeight: UInt32 = 4000
        println(self.lineChartView.frame.height)
        var randomValue: Float = Float(arc4random_uniform(lineChartViewHeight))
        println("added value: \(randomValue)")
        self.lineChartView.addValueToLine(randomValue)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }

}

