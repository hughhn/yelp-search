//
//  Constants.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// #c41200
let yelpRed = UIColor(red: 196.0/255.0, green: 18.0/255.0, blue: 0.0, alpha: 1.0)
let yelpColor1 = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).CGColor
let yelpColor2 = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).CGColor
let yelpColor3 = UIColor(red: 196.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).CGColor
let yelpColor4 = UIColor(red: 255.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).CGColor

let yelpGradientLocations: [Float] = [0.0, 0.2, 0.7, 1.0]

class YelpGradient {
    static func setYelpGradient(button: UIButton) {
        let layer = CAGradientLayer()
        layer.frame = button.layer.bounds
        layer.colors = [yelpColor4, yelpColor3, yelpColor3, yelpColor4]
        layer.locations = yelpGradientLocations
        layer.cornerRadius = button.layer.cornerRadius
        button.layer.addSublayer(layer)
    }
}