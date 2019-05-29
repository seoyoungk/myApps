//
//  ExtensionCLLocationManager.swift
//  TodayRecipe
//
//  Created by Seoyoung on 28/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation
import CoreLocation

extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordi = manager.location?.coordinate {
            let latitude = coordi.latitude
            let longtitude = coordi.longitude
            
            let locationVO = LocationVO.sharedInstance
            locationVO.latitude = latitude
            locationVO.longtitude = longtitude
            
            let currentStation = CurrentStationName()
            currentStation.getTM()
            
            // 현재 위치 label에 넣는다
            currentLocationLabel.text = locationVO.stationLists.first
            self.result = locationVO.stationLists.first ?? ""
            NSLog("result = \(self.result)")
        }
    }
            
}
            
