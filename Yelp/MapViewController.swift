//
//  MapViewController.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc internal protocol MapViewControllerDelegate {
    
    optional func mapViewController(mapViewController: MapViewController, locationUpdated: CLLocation?, completion: (([Business]!, NSError!) -> Void)!)
    
    optional func mapViewController(mapViewController: MapViewController, locationUpdated: CLLocation?, newPrefs: Preferences?, searchTerm: String, completion: (([Business]!, NSError!) -> Void)!)
    
    optional func dismissMapViewController(mapViewController: MapViewController)
    
    optional func getCurrPrefs() -> Preferences
}

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, FiltersViewControllerDelegate {

    weak var delegate: MapViewControllerDelegate?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    var locationManager : CLLocationManager!
    var searchBar = UISearchBar()
    var leftBarBtn: UIBarButtonItem!
    
    var businesses: [Business]? {
        didSet {
            if self.mapView == nil {
                return
            }
            self.loadAnnotations()
        }
    }
    
    var currLocation: CLLocation?
    let span = MKCoordinateSpanMake(0.03, 0.03)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        leftBarBtn = UIBarButtonItem(title: "Filters", style: .Plain, target: self, action: "actionBtnTapped")
        navigationItem.leftBarButtonItem = leftBarBtn
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        //let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        //goToLocation(centerLocation)
        
        locationBtn.hidden = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        loadAnnotations()
    }
    
    func loadAnnotations() {
        if businesses == nil || businesses!.count == 0 {
            return
        }
        
        for (business) in businesses! {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(business.address!, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if error != nil {
                    print(error!)
                }
                if let placemark = placemarks?[0] {
                    let plcmark = MKPlacemark(placemark: placemark)
                    let annotation = YelpAnnotation(coordinate: plcmark.coordinate, business: business)
                    annotation.title = business.name!
                    self.mapView.addAnnotation(annotation)
                }
            })
        }
    }
    
    func goToLocation(location: CLLocation) {
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationBtn.hidden = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            goToLocation(location)
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if !(view.annotation is YelpAnnotation) {
            return
        }
        let yelpAnnotation = view.annotation as! YelpAnnotation
        print(yelpAnnotation.business?.name!)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if !(view.annotation is YelpAnnotation) {
            return
        }
        let yelpAnnotation = view.annotation as! YelpAnnotation
        
        let leftBtn = UIButton(frame: CGRectMake(0, 0, 50, 50))
        leftBtn.setImageForState(UIControlState.Normal, withURL: (yelpAnnotation.business?.imageURL)!)
        leftBtn.layer.masksToBounds = true
        leftBtn.layer.cornerRadius = 5
        
//        let leftImg = UIImageView(frame: CGRectMake(0, 0, 50, 50))
//        leftImg.setImageWithURL((yelpAnnotation.business?.imageURL)!)
//        leftImg.layer.masksToBounds = true
//        leftImg.layer.cornerRadius = 5
        view.leftCalloutAccessoryView = leftBtn
        
        let rightBtn = UIButton(frame: CGRectMake(0, 0, 83, 15))
        rightBtn.setImageForState(UIControlState.Normal, withURL: (yelpAnnotation.business?.ratingImageURL)!)
        rightBtn.layer.masksToBounds = true
        rightBtn.layer.cornerRadius = 5
        view.rightCalloutAccessoryView = rightBtn
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "customAnnotationView"
        
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        
//        if #available(iOS 9.0, *) {
//            annotationView!.pinTintColor = UIColor.greenColor()
//        } else {
//            // Fallback on earlier versions
//            annotationView?.pinColor = .Green
//        }
//        annotationView!.pinColor = .Green
        annotationView!.canShowCallout = true
        
        return annotationView
    }
    
    override func viewDidLayoutSubviews() {
        listBtn.layer.cornerRadius = 0.5 * listBtn.bounds.size.width
        listBtn.layer.borderColor = UIColor.whiteColor().CGColor
        listBtn.layer.borderWidth = 2.0
        listBtn.clipsToBounds = true
        
        let locationImg = UIImage(named: "icon_location_arrow")
        locationBtn.setImage(locationImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        locationBtn.tintColor = UIColor.orangeColor()
    }

    @IBAction func listBtnClicked(sender: AnyObject) {
        delegate?.dismissMapViewController?(self)
    }
    
    @IBAction func locationBtnClicked(sender: AnyObject) {
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        leftBarBtn.title = "Search"
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        leftBarBtn.title = "Filters"
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func actionBtnTapped() {
        if leftBarBtn.title == "Search" {
            delegate?.mapViewController?(self, locationUpdated: currLocation, newPrefs: nil, searchTerm: searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.businesses = businesses
                
                //            for (business) in self.businesses! {
                //                print(business.name!)
                //                print(business.address!)
                //            }
            })
            searchBarCancelButtonClicked(searchBar)
        } else {
            // Filters tapped
            let filtersVC = FiltersViewController()
            let navVC = UINavigationController(rootViewController: filtersVC)
            let prefs = delegate?.getCurrPrefs!()
            
            filtersVC.delegate = self
            filtersVC.prefs = prefs!.copy() as! Preferences
            navigationController?.presentViewController(navVC, animated: true, completion: nil)
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdatePrefs newPrefs: Preferences) {
        delegate?.mapViewController?(self, locationUpdated: currLocation, newPrefs: newPrefs, searchTerm: searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.businesses = businesses
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
