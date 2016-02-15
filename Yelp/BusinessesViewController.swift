//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, FiltersViewControllerDelegate, MapViewControllerDelegate {

    var businesses = [Business]()
    var searchBar = UISearchBar()
    var currSearchTerm: String?
    var currPrefs = Preferences()
    var currLocation: CLLocation?
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionBtn: UIBarButtonItem!
    @IBOutlet weak var mapBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionBtn.target = self
        actionBtn.action = "actionBtnTapped"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 81
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.hidden = true
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        doSearch(nil, searchCompletion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        mapBtn.layer.cornerRadius = 0.5 * mapBtn.bounds.size.width
        mapBtn.clipsToBounds = true
    }
    
    @IBAction func mapBtnClicked(sender: AnyObject) {
        let mapVC = MapViewController()
        mapVC.delegate = self
        mapVC.businesses = self.businesses
        
        //navigationController?.presentViewController(mapVC, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            self.navigationController?.pushViewController(mapVC, animated: false)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
        })
    }
    
    func dismissMapViewController(mapViewController: MapViewController) {
        //navigationController?.popViewControllerAnimated(true)
        
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            self.navigationController?.popViewControllerAnimated(false)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view!, cache: false)
        })
    }
    
    func mapViewController(mapViewController: MapViewController, locationUpdated: CLLocation?, completion: (([Business]!, NSError!) -> Void)!) {
        currLocation = locationUpdated!
        doSearch(nil, searchCompletion: { (businesses: [Business]!, error: NSError!) -> Void in
            completion(businesses, error)
        })
    }
    
    func mapViewController(mapViewController: MapViewController, locationUpdated: CLLocation?, newPrefs: Preferences?, searchTerm: String, completion: (([Business]!, NSError!) -> Void)!) {
        currSearchTerm = searchTerm
        if locationUpdated != nil {
            currLocation = locationUpdated!
        }
        if newPrefs != nil {
            currPrefs = newPrefs!
        }
        doSearch(nil, searchCompletion: { (businesses: [Business]!, error: NSError!) -> Void in
            completion(businesses, error)
        })
    }
    
    func getCurrPrefs() -> Preferences {
        return currPrefs
    }
    
    func doSearch(offset: Int?, searchCompletion: (([Business]!, NSError!) -> Void)?) {
        if offset == nil {
            businesses.removeAll()
            tableView.setContentOffset(CGPoint.zero, animated: true)
            tableView.reloadData()
        }
        if currSearchTerm == nil {
            currSearchTerm = "Restaurants"
        }
        Business.searchWithTerm(currSearchTerm!, sort: currPrefs.sortMode, distance: currPrefs.distance, categories: currPrefs.categories, deals: currPrefs.deal, offset: offset, location: currLocation,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                
                // Update flag
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                self.businesses.appendContentsOf(businesses)
                self.tableView.reloadData()
                self.tableView.hidden = false
                
                if searchCompletion != nil {
                    searchCompletion!(businesses, error)
                }
        })
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        actionBtn.title = "Search"
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        actionBtn.title = "Filters"
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let businessVC = BusinessViewController()
        let business = businesses[indexPath.row]
        businessVC.business = business
        businessVC.coordinate = business.coordinate
        navigationController?.pushViewController(businessVC, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdatePrefs newPrefs: Preferences) {
        currPrefs = newPrefs
        doSearch(nil, searchCompletion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isMoreDataLoading {
            return
        }
        
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
            isMoreDataLoading = true
            
            // Update position of loadingMoreView, and start loading indicator
            let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
            loadingMoreView?.frame = frame
            loadingMoreView!.startAnimating()
            
            doSearch(businesses.count, searchCompletion: nil)
        }
    }
    
    // MARK: - Navigation

    func actionBtnTapped() {
        if actionBtn.title == "Search" {
            currSearchTerm = searchBar.text!
            searchBarCancelButtonClicked(searchBar)
            doSearch(nil, searchCompletion: nil)
        } else {
            let filtersVC = FiltersViewController()
            let navVC = UINavigationController(rootViewController: filtersVC)
            
            filtersVC.delegate = self
            filtersVC.prefs = currPrefs.copy() as! Preferences
            navigationController?.presentViewController(navVC, animated: true, completion: nil)
        }

    }
}
