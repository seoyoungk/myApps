//
//  CurrentStationNameController.swift
//  FIneDust
//
//  Created by Seoyoung on 30/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class CurrentStationName: MainViewController {
    let stationLists = LocationData() // 근접 측정소 찾는 api 및 station 이름을 호출하는 클래스
    let coordinates = Transition() // latitude, longtitude -> TM_x, TM_y로 변환해주는 클래스
    let locationVO = LocationVO.sharedInstance
    
    // 위도, 경도를 이용하여 근접 측정소를 찾는 url을 만들어 api 를 호출하고 최종 근접 측정소를 찾는 함수
    func getTM() {
        
        let currentLocation = CLLocation(latitude: locationVO.latitude, longitude: locationVO.longtitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: Locale(identifier: "ko_KR"), completionHandler: { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                return
                
            }
            if let currentLocationData: LocationVO = self.createCurrentLocationData(currentLocation, placemark: placemark) {
                
                let (TM_x, TM_y) = self.coordinates.convertToPlaneRect(latitude: self.locationVO.latitude, longitude: self.locationVO.longtitude)
                self.locationVO.TM_x = TM_x
                self.locationVO.TM_y = TM_y
                self.locationVO.latitude = currentLocationData.latitude
                self.locationVO.longtitude = currentLocationData.longtitude
                self.locationVO.location = currentLocationData.location
                
                // 근접 측정소 찾는 클래스 객체 생성, 함수 호출
                self.stationLists.callStationListAPI(TM_x: TM_x, TM_y: TM_y)
                self.locationVO.stationLists = self.stationLists.extractStationName(self.stationLists.stationlists) as! [String]
                
                return
                
            }
        })
    }
    
    
    func createCurrentLocationData(_ location: CLLocation, placemark: CLPlacemark) -> LocationVO? {
        if let locality = placemark.locality,
            let subLocality = placemark.subLocality {
            let locationName = locality + " " + subLocality
            let currentLocationDatas = LocationVO.sharedInstance
            currentLocationDatas.location = locationName
            currentLocationDatas.latitude = location.coordinate.latitude
            currentLocationDatas.longtitude = location.coordinate.longitude
            return currentLocationDatas
        }
        return nil
    }
}

