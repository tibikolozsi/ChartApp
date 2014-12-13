//
//  ViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 28/09/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework

public enum ForecastType {
    case ForecastTypeDaily
    case ForecastTypeDefault
}

public protocol ChooseDelegate {
    func choose(city: String)
}



let kSimpleLineString = "Simple Line"
let kBezierCurveString = "Bezier Curve"

class ViewController: UIViewController, UIScrollViewDelegate, LineChartDataSource, ChooseDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var navItem: UINavigationItem!
    
//    var values = Array<Float>()
    var cityToFetch = ""
    var data = Array<TempData>()
    var API:OWMWeatherAPI = OWMWeatherAPI()
    var forecastType:ForecastType = ForecastType.ForecastTypeDefault
    @IBOutlet weak var forecastTypeSegementedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.values = Array<Float>()
        self.data = Array<TempData>()
        self.lineChartView.dataSource = self
//        for i in 1...50 {
//            addRandomValueToLine()
//        }
//        self.lineChartView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
         self.cityToFetch = "Perth"
        
        self.initWeatherApi()
        self.loadWeatherData(self.cityToFetch, type:ForecastType.ForecastTypeDefault)
    }
    
    @IBAction func forecastTypeChanged(sender: AnyObject) {
        switch(self.forecastTypeSegementedControl.selectedSegmentIndex) {
        case 0:
            self.forecastType = ForecastType.ForecastTypeDaily
        case 1:
            self.forecastType = ForecastType.ForecastTypeDefault
        default:
            break
        }
        self.loadWeatherData(self.cityToFetch, type: self.forecastType)
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
            changeLineTypeButton.title = kSimpleLineString
        } else if self.lineChartView.lineType == LineType.LineTypeSpline {
            self.lineChartView.lineType = LineType.LineTypeSimple
            changeLineTypeButton.title = kBezierCurveString
        }
    }
    @IBAction func addNewPointToLine(sender: AnyObject) {
        addRandomValueToLine()
    }
    
    func addRandomValueToLine() {
        let lineChartViewHeight: UInt32 = 4000
        var randomValue: Float = Float(arc4random_uniform(lineChartViewHeight))-2000
//        self.values.append(randomValue)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    func lineChartNumberOfData(lineChart: LineChartView) -> Int {
        return self.data.count
//        return self.values.count
    }
    
    func lineChartValueForData(linechart: LineChartView, index: Int) -> Float {
        var current = self.data[index]
        if (current.temperature != nil) {
            return current.temperature!
        } else {
            return 0.0
        }

    }
    
    func lineChartTextForData(lineChart: LineChartView, index: Int) -> String {
        var current = self.data[index]
        return current.dateString
    }
    
    func lineChartDotColorForData(lineChart: LineChartView, index: Int) -> UIColor {
        return UIColor.whiteColor()
//        return (index % 2 == 0 ) ? UIColor.blueColor() : UIColor.redColor()
    }
    
    func initWeatherApi() {
        self.API = OWMWeatherAPI(APIKey: "5b713fcabb74b7a01ec9332cd11b5833")
        self.API.setTemperatureFormat(kOWMTempCelcius)
        self.API.setLangWithPreferedLanguage()
    }
    
    func loadWeatherData(city:String, type:ForecastType) {
        
        var cityName:String = ""
        var currentTemperature:Float = -1000
        var currentTimeStamp:NSDate = NSDate()
        var weatherDesc:String
        
        self.API.currentWeatherByCityName(city, withCallback: {(error: NSError!, result:[NSObject : AnyObject]!) -> Void in
            if error != nil {
                println("error!!")
                return
            }
            
            var city = result["name"] as? String
            var sysDict = result["sys"] as? [String : AnyObject]!
            var country = sysDict!["country"] as? String
            cityName = city! + ", " + country!
            self.navItem.title = cityName
            
            var mainDict = result["main"] as [String : AnyObject]!
            currentTemperature = mainDict["temp"] as Float
            
            currentTimeStamp = result["dt"] as NSDate
        })
        
        switch (type) {
            case .ForecastTypeDefault:
                self.lineChartView.axisLabelDiff = 1
                self.API.forecastWeatherByCityName(city, withCallback: {(error: NSError!, result:[NSObject : AnyObject]!) -> Void in
                    if error != nil {
                        println("error!!")
                        return
                    }
                    
                    var tempDataArray = result["list"] as [AnyObject]
                    self.data = Array<TempData>()
                    for i in tempDataArray {
                        let tempDataJSON = i as [String : AnyObject]
                        var t:TempData = TempData.init(json:tempDataJSON)
                        self.data.append(t)
                    }
                    self.lineChartView.reloadData()
                })
            case .ForecastTypeDaily:
                                self.lineChartView.axisLabelDiff = 1
                self.API.dailyForecastWeatherByCityName(city, withCount: 7, andCallback: {(error: NSError!, result:[NSObject : AnyObject]!) -> Void in
                    if error != nil {
                        println("error!!")
                        return
                    }
                    println(result)
                    
                    var tempDataArray = result["list"] as [AnyObject]
                    self.data = Array<TempData>()
                    for i in tempDataArray {
                        let tempDataJSON = i as [String : AnyObject]
                        var t:TempData = TempData.init(json:tempDataJSON)
                        self.data.append(t)
                    }
                    self.lineChartView.reloadData()
                })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "ChooseCitySegue" {
                let dest:ChooseViewController = segue.destinationViewController as ChooseViewController
                dest.delegate = self
            }
        }
    }
    
    func choose(city: String) {
        self.cityToFetch = city
        self.loadWeatherData(city, type: .ForecastTypeDefault)
    }
    


}

