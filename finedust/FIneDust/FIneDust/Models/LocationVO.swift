//
//  LocationVO.swift
//  FIneDust
//
//  Created by Seoyoung on 30/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation

class LocationVO {
    static let sharedInstance = LocationVO()
    var location: String
    var stationLists: [String]
    var latitude: Double
    var longtitude: Double
    var TM_x: Double
    var TM_y: Double
    
    private init() {
        self.location = ""
        self.stationLists = []
        self.latitude = 0.0
        self.longtitude = 0.0
        self.TM_x = 0.0
        self.TM_y = 0.0
    }
}
