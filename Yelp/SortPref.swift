//
//  SortPref.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

enum SortPref : String {
    case SortBestMatch = "Best Match"
    case SortDistance = "Distance"
    case SortHighestRated = "Highest Rated"
    
    static let allValues = [SortBestMatch, SortDistance, SortHighestRated]
    
    func toYelpSortMode() -> YelpSortMode {
        switch self {
        case .SortBestMatch:
            return YelpSortMode.BestMatched
        case .SortDistance:
            return YelpSortMode.Distance
        case .SortHighestRated:
            return YelpSortMode.HighestRated
        }
    }
}
