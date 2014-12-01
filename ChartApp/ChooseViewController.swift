//
//  ChooseViewController.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 30/11/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    let data = ["Perth", "Budapest", "Sydney", "London", "Paris", "Berlin"]
    var delegate:ChooseDelegate?
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("row selected")
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.data[row]
    }
    
    override func viewDidDisappear(animated: Bool) {
        let city = self.data[self.pickerView.selectedRowInComponent(0)]
        self.delegate?.choose(city)
        println("dismiss")
    }
    
}
