//
//  MapViewController.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

@objc internal protocol MapViewControllerDelegate {
    
    optional func dismissMapViewController(mapViewController: MapViewController)
}

class MapViewController: UIViewController {

    weak var delegate: MapViewControllerDelegate?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        listBtn.layer.cornerRadius = 0.5 * listBtn.bounds.size.width
        listBtn.clipsToBounds = true
    }

    @IBAction func listBtnClicked(sender: AnyObject) {
        delegate?.dismissMapViewController?(self)
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
