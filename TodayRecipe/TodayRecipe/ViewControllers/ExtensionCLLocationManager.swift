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
            // locationData에 위도, 경도 정보 넣기
            locationData.latitude = latitude
            locationData.longtitude = longtitude
            
            // 위도, 경도를 TM_x, TM_y로 변환 후 근접 측정소 목록 뽑아온다
            let currentStation = CurrentStationName()
            currentStation.getTM()
     
            // 현재 위치 label에 넣는다
            let result = currentStation.locationVO.stationLists.first
            currentLocationLabel.text = result

        }
    }  
            
}


