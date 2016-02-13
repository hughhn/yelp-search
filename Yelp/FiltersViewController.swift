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
        didUpdatePrefs newPrefs: Preferences)
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

    var currentPrefs: Preferences!
    var categories: [[String:String]]!
    
    let tableStructure: [[PrefRowIdentifier]] = [
        [.Deal],
        [.DistanceAuto, .Distance03, .Distance1, .Distance5, .Distance20],
        [.SortBestMatch, .SortDistance, .SortHighestRated],
        []]
    
    var sectionExpanded = [true, false, false, true]
    
    
    var switchStates = [Int:Bool]()
    var prefValues: [PrefRowIdentifier: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.registerNib(UINib(nibName: "DropdownCell", bundle: nil), forCellReuseIdentifier: "DropdownCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 0 {
            ///put in your code to toggle your boolean value here
            sectionExpanded[indexPath.section] = !sectionExpanded[indexPath.section]
            
            // reload this section
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == (tableStructure.count - 1) {
            return categories.count
        } else {
            if sectionExpanded[section] {
                return tableStructure[section].count
            } else {
                return 1
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == (tableStructure.count - 1) || indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            if indexPath.section == (tableStructure.count - 1) {
                cell.delegate = self
                cell.switchLabel.text = categories[indexPath.row]["name"]
                cell.onSwitch.on = currentPrefs.categories.contains(categories[indexPath.row]["code"]!)
            } else {
                let prefIdentifier = tableStructure[indexPath.section][indexPath.row]
                cell.switchLabel.text = prefIdentifier.rawValue
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropdownCell", forIndexPath: indexPath) as! DropdownCell
            let prefIdentifier = tableStructure[indexPath.section][indexPath.row]
            cell.dropdownLabel.text = prefIdentifier.rawValue
            return cell
        }
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
        delegate?.filtersViewController?(self, didUpdatePrefs: preferencesFromTableData())
    }
    
    func preferencesFromTableData() -> Preferences {
        var newPrefs = Preferences()
        //newPrefs.deal
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        newPrefs.categories = selectedCategories
        
        return newPrefs
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
