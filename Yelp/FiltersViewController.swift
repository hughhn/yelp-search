//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Hugo Nguyen on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController,
        didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?

    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        switchStates[indexPath.row] = value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name": "Afghan", "code": "afghani"],
        ["name": "African", "code": "african"],
        ["name": "American, New", "code": "newamerican"]]
    }

}
