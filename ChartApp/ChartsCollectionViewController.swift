//
//  ChartsCollectionViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 13/12/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit
import ChartFramework

let reuseIdentifier = "ChartCell"
let numberOfCells = 6

class ChartsCollectionViewController: UICollectionViewController, PieChartDataSource {

    var pieChartViews:Array<PieChartView> = Array<PieChartView>()
    var data:Array<Array<CGFloat>> = Array<Array<CGFloat>>()
    override func viewDidLoad() {
        self.pieChartViews = Array<PieChartView>()
        super.viewDidLoad()
        
        data = [[20,80],[25,75],[30,70],[30,60,10],[30,50,20],[30,40,20,10]]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ChartCollectionViewCell
        cell.titleLabel.text = "Sample \(indexPath.row+1)"
        cell.pieChartView.dataSource = self
        self.pieChartViews.append(cell.pieChartView)
        return cell
    
    }
    
    func numberOfSlicesInPieChart(pieChart: PieChartView) -> Int {
        let index = find(self.pieChartViews, pieChart)
        let arrayData = data[index!]
        return arrayData.count
    }
    
    func valueForSlice(pieChart: PieChartView, index: Int) -> CGFloat {
        let fIndex = find(self.pieChartViews, pieChart)
        let arrayData = data[fIndex!]
        return arrayData[index]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        for pieChartView in self.pieChartViews {
            pieChartView.reloadData()
        }
    }

    
}
