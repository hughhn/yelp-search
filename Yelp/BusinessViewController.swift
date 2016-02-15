//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var snippetLabel: UILabel!
    
    var business: Business!
    var coordinate: CLLocationCoordinate2D!
    var locationManager: CLLocationManager!
    
    override func viewDidLayoutSubviews() {
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        navigationController?.navigationBar.translucent = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false;
        
        // Do any additional setup after loading the view.
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        nameLabel.text = business.name
        distanceLabel.text = business.distance
        ratingsCountLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = business.displayAddress
        categoriesLabel.text = business.categories
        ratingImageView.setImageWithURL(business.ratingImageURL!)
        
        businessImageView.setImageWithURL(business.imageURL!)
        businessImageView.layer.cornerRadius = 5
        
        let locale = NSLocale.currentLocale()
        let qBegin = locale.objectForKey(NSLocaleQuotationBeginDelimiterKey) as? String ?? "\""
        let qEnd = locale.objectForKey(NSLocaleQuotationEndDelimiterKey) as? String ?? "\""
        let snippet = qBegin + business.snippet! + qEnd
        
        snippetLabel.text = snippet
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = business.coordinate!
        mapView.addAnnotation(annotation)
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        goToLocation(business.coordinate!)
    }
    
    func goToLocation(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(location, 1500, 1500)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
