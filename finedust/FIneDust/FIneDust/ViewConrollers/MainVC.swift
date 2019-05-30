//
//  ViewController.swift
//  FIneDust
//
//  Created by Seoyoung on 30/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, XMLParserDelegate {
    var airPollutionData = AirPollutionData()
    var airPollutionCount = 6
    
    enum AirPollutionIndex: Int {
        case khai, pm10, co, no2, o3, so2
    }
    
    var lists = [[String: Any]]()
    var list = [String: Any]()
    var elementTemp: String = ""
    var blank: Bool = false
    
    // locationData 선언  -> extension에서 값 저장해줌
    let locationData = LocationVO.sharedInstance
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var currentConditionImage: UIImageView!
    @IBOutlet weak var currentStationLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self
        // 미세먼지 API를 호출
        callAirAPI()
        
        // 현재 시각
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        currentTimeLabel.text = dateFormatter.string(from: date)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        // 위치추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 베터리로 동작할 때 권장되는 가장 높은 수준의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    // 미세먼지 API를 호출하는 메소드
    func callAirAPI() {
        // func cellAirAPI(data: Any){
        let key = "Mj2lJctNluJLoMz0XV5F8XU0cGhTI2xNmVjB4fk%2BbojkGWq8%2F6PpOHbMVYrIKAxLQk8NgR7kPnJ%2BPD08HKqBEQ%3D%3D"
        let urlString = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=%EA%B0%95%EB%82%A8%EA%B5%AC&dataTerm=month&pageNo=1&numOfRows=10&ServiceKey=\(key)"
        
        //        finalURL에 locationData에서 얻은 측정소 이름을 넣어서 호출
        //        let finalURL = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=\(data)&dataTerm=month&pageNo=1&numOfRows=10&ServiceKey=\(key)"
        
        guard let url = URL(string: urlString) else {
            #if DEBUG
            print("URL error!")
            #endif
            return
        }
        guard let parser = XMLParser(contentsOf: url) else {
            return
        }
        
        parser.delegate = self
        
        if (parser.parse()) {
            #if DEBUG
            print("Successfully Parsed")
            #endif
            
        }
    }
    // xml parser
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        elementTemp = elementName
        blank = true
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if blank == true && elementTemp != "response" && elementTemp != "header" && elementTemp != "resultCode" && elementTemp != "resultMsg" && elementTemp != "body" {
            list[elementTemp] = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        #if DEBUG
        print("string: \(string)")
        print("item: \(list)")
        #endif
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            lists += [list]
        }
        blank = false
        
        #if DEBUG
        print("end: \(elementName)")
        print("---------------------------------------")
        print("lists = \(lists)")
        #endif
        
        // 현재 대기상태 label 업데이트
        currentConditionLabel.text = airPollutionData.getCurrentData(lists)?.khaiGrade ?? ""
    }
    
}


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
            currentStationLabel.text = result
            currentLocationLabel.text = currentStation.locationVO.location
            
        }
    }
    
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return airPollutionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AirPollutionCell
        
        switch indexPath.row {
        case AirPollutionIndex.khai.rawValue:
            cell.typeLabel.text = "통합대기환경"
            cell.conditionLabel.text = airPollutionData.getCurrentData(lists)?.khaiGrade ?? ""
            cell.valueLabel.text = airPollutionData.getCurrentData(lists)?.khaiValue ?? ""
        case AirPollutionIndex.pm10.rawValue:
            cell.typeLabel.text = "미세먼지"
            cell.conditionLabel.text = airPollutionData.getCurrentData(lists)?.pm10Grade ?? ""
            cell.valueLabel.text = airPollutionData.getCurrentData(lists)?.pm10Value ?? ""
        case AirPollutionIndex.co.rawValue:
            cell.typeLabel.text = "일산화탄소"
            cell.conditionLabel.text = airPollutionData.getCurrentData(lists)?.coGrade ?? ""
            cell.valueLabel.text = airPollutionData.getCurrentData(lists)?.coValue ?? ""
        case AirPollutionIndex.no2.rawValue:
            cell.typeLabel.text = "이산화탄소"
            cell.conditionLabel.text = airPollutionData.getCurrentData(lists)?.no2Grade ?? ""
            cell.valueLabel.text = airPollutionData.getCurrentData(lists)?.no2Value ?? ""
        case AirPollutionIndex.o3.rawValue:
            cell.typeLabel.text = "오존"
            cell.conditionLabel.text = airPollutionData.getCurrentData(lists)?.o3Grade ?? ""
            cell.valueLabel.text = airPollutionData.getCurrentData(lists)?.o3Value ?? ""
        case AirPollutionIndex.so2.rawValue:
            cell.typeLabel.text = "아황산가스"
            cell.conditionLabel.text = airPollutionData.getCurrentData(lists)?.so2Grade ?? ""
            cell.valueLabel.text = airPollutionData.getCurrentData(lists)?.so2Value ?? ""
            
        default: break
        }
        
        return cell
    }
}
