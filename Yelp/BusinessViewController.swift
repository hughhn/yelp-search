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

class BusinessViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business!
    var coordinate: CLLocationCoordinate2D!
    
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
        addressLabel.text = business.address
        categoriesLabel.text = business.categories
        ratingImageView.setImageWithURL(business.ratingImageURL!)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = business.coordinate!
        mapView.addAnnotation(annotation)
        
        goToLocation(business.coordinate!)
    }
    
    func goToLocation(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        mapView.setRegion(region, animated: false)
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
