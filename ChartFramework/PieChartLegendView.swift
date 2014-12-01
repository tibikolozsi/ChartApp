//
//  PieChartLegendView.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 01/12/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit

public class PieChartLegendView: UITableView {

    public func initAll() {
        self.scrollEnabled = false
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initAll()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        self.initAll()
    }
}
