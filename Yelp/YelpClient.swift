//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "puVL6WFH1OXF-fj-ctQNPA"
let yelpConsumerSecret = "FNbUUIsD80F8sJmGelpwzEBo4H0"
let yelpToken = "4jw5mQtqGMYi3G25kR1OU4xGRxJ-EE7c"
let yelpTokenSecret = "SfK3CErRMec9YJldHOkFp_l39UE"

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
    
    static let allValues = [BestMatched, Distance, HighestRated]
    
    func toDisplayString() -> String {
        switch self {
        case .BestMatched:
            return "Best Matched"
        case .Distance:
            return "Distance"
        case .HighestRated:
            return "Highest Rated"
        }
    }
}

enum YelpDistance: Float {
    case DistanceAuto = 0
    case Distance03 = 0.3
    case Distance1 = 1
    case Distance5 = 5
    case Distance20 = 20
    
    static let allValues = [DistanceAuto, Distance03, Distance1, Distance5, Distance20]
    
    func toDisplayString() -> String {
        switch self {
        case .DistanceAuto:
            return "Auto"
        case .Distance03:
            return "0.3 miles"
        case .Distance1:
            return "1 mile"
        case .Distance5:
            return "5 miles"
        case .Distance20:
            return "20 miles"
        }
    }
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, distance: nil, categories: nil, deals: nil, offset: nil, completion: completion)
    }
    
    func searchWithTerm(term: String, sort: YelpSortMode?, distance: YelpDistance?, categories: [String]?, deals: Bool?, offset: Int?, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api

        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term, "ll": "37.785771,-122.406165", "limit": "20"]

        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if distance != nil && distance! != .DistanceAuto {
            parameters["radius_filter"] = distance!.rawValue
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joinWithSeparator(",")
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals!
        }
        
        if offset != nil {
            parameters["offset"] = offset!
        }
        
        print(parameters)
        
        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let dictionaries = response["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                completion(Business.businesses(array: dictionaries!), nil)
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                completion(nil, error)
        })!
    }
}
