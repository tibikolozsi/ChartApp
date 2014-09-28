//
//  Logger.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 28/09/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit

class Logger: NSObject {
    class func Log(logMessage: String = "", functionName: String = __FUNCTION__) {
        println("\(functionName): \(logMessage)")
    }
}
