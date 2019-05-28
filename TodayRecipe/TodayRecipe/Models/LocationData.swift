//
//  LocationData.swift
//  TodayRecipe
//
//  Created by Seoyoung on 28/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation
import CoreData

class LocationData {
    let locationData = LocationVO()
    var siteURL = ""
    func reverseGeoCoder() {
        siteURL = "https://apis.daum.net/local/geo/coord2addr?apikey=777406297ef0059738b4a3d795979c07&inputCoordSystem=WGS84&y=\(locationData.latitude)&x=\(locationData.longtitude)&output=xml"
        NSLog("\(locationData.latitude)")
    }
}

