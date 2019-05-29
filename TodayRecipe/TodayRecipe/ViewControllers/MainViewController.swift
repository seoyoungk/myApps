//
//  MainViewController.swift
//  TodayRecipe
//
//  Created by Seoyoung on 23/05/2019.
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
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self
        // 미세먼지 API를 호출
        cellAirAPI()

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
    func cellAirAPI() {
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
        
        currentConditionLabel.text = airPollutionData.currentData(lists)?.khaiGrade ?? ""
    }
    
    
}
