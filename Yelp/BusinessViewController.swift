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
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business!
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        nameLabel.text = business.name
        distanceLabel.text = business.distance
        ratingsCountLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = business.address
        categoriesLabel.text = business.categories
        
        businessImageView.setImageWithURL(business.imageURL!)
        ratingImageView.setImageWithURL(business.ratingImageURL!)
        
        businessImageView.layer.cornerRadius = 5
        
        let centerLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        goToLocation(centerLocation)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
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
