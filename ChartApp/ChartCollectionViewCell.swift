//
//  ChartCollectionViewCell.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 13/12/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework

class ChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var titleLabel: UILabel!
}
