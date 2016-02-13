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

class SectionInfo {
    var header: String?
    var expandable: Bool
    var expanded: Bool
    var expandedSize: Int
    var unexpandedSize: Int
    var sectionType: String
    
    init(header: String?, expandable: Bool, expanded: Bool, expandedSize: Int, sectionType: String) {
        if header != nil {
            self.header = header
        }
        self.expandable = expandable
        self.expanded = expanded
        self.expandedSize = expandedSize
        self.unexpandedSize = 1
        self.sectionType = sectionType
    }
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    var prefs: Preferences!
    var categories: [Category]!
    var tableStructure: [SectionInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCategoriesSelected()
        initTableView()
    }
    
    func initCategoriesSelected() {
        categories = yelpCategories()
        for (category) in categories {
            category.selected = prefs.categories.contains(category.code)
        }
    }
    
    func initTableView() {
        tableStructure = [
            SectionInfo(header: nil, expandable: false, expanded: false, expandedSize: 1, sectionType: "Deal"),
            SectionInfo(header: "Distance", expandable: true, expanded: false, expandedSize: YelpDistance.allValues.count, sectionType: "Distance"),
            SectionInfo(header: "Sort By", expandable: true, expanded: false, expandedSize: YelpSortMode.allValues.count, sectionType: "Sort"),
            SectionInfo(header: "Category", expandable: false, expanded: false, expandedSize: categories.count, sectionType: "Categories")
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.registerNib(UINib(nibName: "DropdownCell", bundle: nil), forCellReuseIdentifier: "DropdownCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableStructure.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableStructure[section].header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableStructure[indexPath.section].expandable {
            tableStructure[indexPath.section].expanded = !tableStructure[indexPath.section].expanded
            
            // reload this section
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableStructure[section].expandable && !tableStructure[section].expanded {
            return tableStructure[section].unexpandedSize
        }
        
        return tableStructure[section].expandedSize
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableStructure[indexPath.section].sectionType == "Deal" {
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.delegate = self
            cell.switchLabel.text = "Offering a Deal"
            cell.onSwitch.on = prefs.deal
            
            return cell
        } else if tableStructure[indexPath.section].sectionType == "Distance" {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropdownCell", forIndexPath: indexPath) as! DropdownCell
            
            if tableStructure[indexPath.section].expanded {
                let dropdownValue = YelpDistance.allValues[indexPath.row]
                cell.dropdownLabel.text = dropdownValue.toDisplayString()
                if dropdownValue == prefs.distance {
                    cell.dropdownImg.image = UIImage(named: "icon_checked_circle")
                } else {
                    cell.dropdownImg.image = UIImage(named: "icon_empty_circle")
                }
            } else {
                cell.dropdownLabel.text = prefs.distance.toDisplayString()
                cell.dropdownImg.image = UIImage(named: "icon_dropdown")
            }
            
            return cell
        } else if tableStructure[indexPath.section].sectionType == "Sort" {
            let cell = tableView.dequeueReusableCellWithIdentifier("DropdownCell", forIndexPath: indexPath) as! DropdownCell
            
            if tableStructure[indexPath.section].expanded {
                let dropdownValue = YelpSortMode.allValues[indexPath.row]
                cell.dropdownLabel.text = dropdownValue.toDisplayString()
                if dropdownValue == prefs.sortMode {
                    cell.dropdownImg.image = UIImage(named: "icon_checked_circle")
                } else {
                    cell.dropdownImg.image = UIImage(named: "icon_empty_circle")
                }
            } else {
                cell.dropdownLabel.text = prefs.sortMode.toDisplayString()
                cell.dropdownImg.image = UIImage(named: "icon_dropdown")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.delegate = self
            cell.switchLabel.text = categories[indexPath.row].name
            cell.onSwitch.on = prefs.categories.contains(categories[indexPath.row].code)
            
            return cell
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        if tableStructure[indexPath.section].sectionType == "Deal" {
            prefs.deal = value
        } else if tableStructure[indexPath.section].sectionType == "Categories" {
            categories[indexPath.row].selected = value
        }
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
        var selectedCategories = [String]()
        for (category) in categories {
            if category.selected {
                selectedCategories.append(category.code)
            }
        }
        
        prefs.categories = selectedCategories
        
        return prefs
    }
    
    func yelpCategories() -> [Category] {
        return [
            Category(name: "French", code: "french", selected: false),
            Category(name: "Korean", code: "korean", selected: false),
            Category(name: "Japanese", code: "japanese", selected: false),
            Category(name: "Sushi", code: "sushi", selected: false),
            Category(name: "Tapas", code: "tapas", selected: false),
            Category(name: "Thai", code: "thai", selected: false),
            Category(name: "Vietnamese", code: "vietnamese", selected: false)
        ]
    }

}
