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

enum PrefRowIdentifier : String {
    case Deal = "Deal"
    case DistanceAuto = "Auto"
    case Distance03 = "0.3 miles"
    case Distance1 = "1 mile"
    case Distance5 = "5 miles"
    case Distance20 = "20 miles"
    case SortBestMatch = "Best Match"
    case SortDistance = "Distance"
    case SortHighestRated = "Highest Rated"
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?

    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    let tableStructure: [[PrefRowIdentifier]] = [
        [.Deal],
        [.DistanceAuto, .Distance03, .Distance1, .Distance5, .Distance20],
        [.SortBestMatch, .SortDistance, .SortHighestRated]]
    
    var prefValues: [PrefRowIdentifier: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count + 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Categories"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == tableStructure.count) {
            return categories.count
        } else {
            return tableStructure[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        if (indexPath.section == tableStructure.count) {
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
        } else {
            let prefIdentifier = tableStructure[indexPath.section][indexPath.row]
            cell.prefRowIdentifier = prefIdentifier
        }
        
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
        return [
        ["name": "French", "code": "french"],
        ["name": "Korean", "code": "korean"],
        ["name": "Japanese", "code": "japanese"],
        ["name": "Sushi", "code": "sushi"],
        ["name": "Tapas", "code": "tapas"],
        ["name": "Thai", "code": "thai"],
        ["name": "Vietnamese", "code": "vietnamese"]
        ]
    }

}
