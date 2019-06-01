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
    var tmX: Double
    var tmY: Double

    private init() {
        self.location = ""
        self.stationLists = []
        self.latitude = 0.0
        self.longtitude = 0.0
        self.tmX = 0.0
        self.tmY = 0.0
    }

}
