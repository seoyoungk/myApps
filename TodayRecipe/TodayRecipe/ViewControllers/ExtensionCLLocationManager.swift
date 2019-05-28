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
            
            let stationLists = LocationData()
            let coordinates = Transition()
            
            let currentLocation = CLLocation(latitude: latitude, longitude: longtitude)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: Locale(identifier: "ko_KR"), completionHandler: { (placemarks, error) in
                guard let placemark = placemarks?.first, error == nil else {
                    return
                }
                if let currentLocationData: LocationVO = self.createCurrentLocationData(currentLocation, placemark: placemark) {
                    self.locationData = currentLocationData
                    let (TM_x, TM_y) = coordinates.convertToPlaneRect(latitude: latitude, longitude: longtitude)
                    self.locationData.TM_x = TM_x
                    self.locationData.TM_y = TM_y
                    
                    // 근접 측정소 찾는 클래스 객체 생성, 함수 호출
                    stationLists.stationListURL(TM_x: TM_x, TM_y: TM_y)
                    var resultStationName = stationLists.extractStationName(stationLists.stationlists) as! [String]
                    
//                    NSLog("latitude = \(latitude), longtitude = \(longtitude), locationData = \(self.locationData), TM_x = \(TM_x), TM_y = \(TM_y), \(result ?? "")")
                    
                    // 현재 위치 label에 넣는다
                    self.currentLocationLabel.text = resultStationName[0]
                    
                    return
                }
                
            })
        }
    }
    
    func createCurrentLocationData(_ location: CLLocation, placemark: CLPlacemark) -> LocationVO? {
        if let locality = placemark.locality,
            let subLocality = placemark.subLocality {
            let locationName = locality + " " + subLocality
            var currentLocationDatas = LocationVO()
            currentLocationDatas.location = locationName
            currentLocationDatas.latitude = location.coordinate.latitude
            currentLocationDatas.longtitude = location.coordinate.longitude
            return currentLocationDatas
        }
        return nil
    }
}
