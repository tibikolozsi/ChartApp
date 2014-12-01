//
//  TempData.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 30/11/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit

class TempData: NSObject {
    var descriptionShort:String
    var descriptionLong:String
    var dateString:String
    var humidity:Float?
    var pressure:Float?
    var temperature:Float?
    var temperatureMax:Float?
    var temperatureMin:Float?
    
    
    required init(json: NSDictionary) {
        var weatherDict = (json.objectForKey("weather") as NSArray).firstObject as NSDictionary
        self.descriptionLong = weatherDict["description"] as String
        self.descriptionShort = weatherDict["main"] as String

        var date = json["dt"] as NSDate
        let dateFormatter = NSDateFormatter()
        var mainDict = json.objectForKey("main") as? NSDictionary
        if let mDict = mainDict { // forecast default
            self.humidity = mDict["humidity"] as? Float
            self.pressure = mDict["pressure"] as? Float
            self.temperature = mDict["temp"] as? Float
            self.temperatureMin = mDict["temp_min"] as? Float
            self.temperatureMax = mDict["temp_max"] as? Float
            dateFormatter.dateFormat = "MM:dd HH:mm"
        } else { // daily
            self.humidity = json["humidity"] as? Float
            self.pressure = json["pressure"] as? Float
            var temperatureDict = json.objectForKey("temp") as? NSDictionary
            if let tDict = temperatureDict {
                self.temperature = tDict["day"] as? Float
                self.temperatureMin = tDict["min"] as? Float
                self.temperatureMax = tDict["max"] as? Float
            }
            dateFormatter.dateFormat = "MM:dd"
        }
        self.dateString = dateFormatter.stringFromDate(date)
        self.temperature = ceil(self.temperature!)
        super.init()

    }
}
