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
    
    optional func mapViewController(mapViewController: MapViewController, locationUpdated: CLLocation?, searchTerm: String, completion: (([Business]!, NSError!) -> Void)!)
    
    optional func dismissMapViewController(mapViewController: MapViewController)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {

    weak var delegate: MapViewControllerDelegate?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    var locationManager : CLLocationManager!
    var searchBar = UISearchBar()
    var rightBarBtn: UIBarButtonItem!
    
    var businesses: [Business]?
    var annotations = [MKPointAnnotation]()
    
    var currLocation: CLLocation?
    var centerLocation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        rightBarBtn = UIBarButtonItem(title: "Search", style: .Plain, target: self, action: "searchTapped")

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
        if annotations.count > 0 {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
        
        if businesses == nil || businesses!.count == 0 {
            return
        }
        
        for (business) in businesses! {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(business.address!, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemark = placemarks?[0] {
                    let plcmark = MKPlacemark(placemark: placemark)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = plcmark.coordinate
                    annotation.title = business.name!
                    self.mapView.addAnnotation(annotation)
                    self.annotations.append(annotation)
                }
            })
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
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
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            goToLocation(location)
        }
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
        }
        else {
            annotationView!.annotation = annotation
        }
        if #available(iOS 9.0, *) {
            annotationView!.pinTintColor = UIColor.greenColor()
        } else {
            // Fallback on earlier versions
        }
        
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
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        navigationItem.rightBarButtonItem = nil
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchTapped() {
        delegate?.mapViewController?(self, locationUpdated: currLocation, searchTerm: searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
//            for (business) in self.businesses! {
//                print(business.name!)
//                print(business.address!)
//            }
            self.loadAnnotations()
        })
        searchBarCancelButtonClicked(searchBar)
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
