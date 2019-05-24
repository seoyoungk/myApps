//
//  MainViewController.swift
//  TodayRecipe
//
//  Created by Seoyoung on 23/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit


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
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        cellAirAPI()
    }
    
    // 미세먼지 API를 호출하는 메소드
    func cellAirAPI() {
        let key = "Mj2lJctNluJLoMz0XV5F8XU0cGhTI2xNmVjB4fk%2BbojkGWq8%2F6PpOHbMVYrIKAxLQk8NgR7kPnJ%2BPD08HKqBEQ%3D%3D"
        let urlString = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=%EA%B0%95%EB%82%A8%EA%B5%AC&dataTerm=month&pageNo=1&numOfRows=10&ServiceKey=\(key)&ever=1.3"
        
        guard let url = URL(string: urlString) else {
            print("URL error!")
            return
        }
        guard let parser = XMLParser(contentsOf: url) else {
            print("Can't read data")
            return
        }
        
        parser.delegate = self
        if (parser.parse()) {
            print("Successfully Parsed")
            
            // 현재 시간
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            currentTimeLabel.text = dateFormatter.string(from: date)
            
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        elementTemp = elementName
        blank = true
        print("start : \(elementName)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if blank == true && elementTemp != "response" && elementTemp != "header" && elementTemp != "resultCode" && elementTemp != "resultMsg" && elementTemp != "body" {
            
            list[elementTemp] = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
            print("string: \(string)")
            print("item: \(list)")
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            lists += [list]
        }
        blank = false
        print("end: \(elementName)")
        print("---------------------------------------")
        print("lists = \(lists)")
        
        currentConditionLabel.text = airPollutionData.currentData(lists)?.khaiGrade ?? ""
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
            cell.conditionLabel.text = airPollutionData.currentData(lists)?.khaiGrade ?? ""
            cell.valueLabel.text = airPollutionData.currentData(lists)?.khaiValue ?? ""
        case AirPollutionIndex.pm10.rawValue:
            cell.typeLabel.text = "미세먼지"
            cell.conditionLabel.text = airPollutionData.currentData(lists)?.pm10Grade ?? ""
            cell.valueLabel.text = airPollutionData.currentData(lists)?.pm10Value ?? ""
        case AirPollutionIndex.co.rawValue:
            cell.typeLabel.text = "일산화탄소"
            cell.conditionLabel.text = airPollutionData.currentData(lists)?.coGrade ?? ""
            cell.valueLabel.text = airPollutionData.currentData(lists)?.coValue ?? ""
        case AirPollutionIndex.no2.rawValue:
            cell.typeLabel.text = "이산화탄소"
            cell.conditionLabel.text = airPollutionData.currentData(lists)?.no2Grade ?? ""
            cell.valueLabel.text = airPollutionData.currentData(lists)?.no2Value ?? ""
        case AirPollutionIndex.o3.rawValue:
            cell.typeLabel.text = "오존"
            cell.conditionLabel.text = airPollutionData.currentData(lists)?.o3Grade ?? ""
            cell.valueLabel.text = airPollutionData.currentData(lists)?.o3Value ?? ""
        case AirPollutionIndex.so2.rawValue:
            cell.typeLabel.text = "아황산가스"
            cell.conditionLabel.text = airPollutionData.currentData(lists)?.so2Grade ?? ""
            cell.valueLabel.text = airPollutionData.currentData(lists)?.so2Value ?? ""
        
        default: break
        }
        
        return cell
    }
}
