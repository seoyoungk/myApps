//
//  LocationData.swift
//  FIneDust
//
//  Created by Seoyoung on 30/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation
import CoreData


class LocationData: MainVC {
    
    var stationlists = [[String: Any]]()
    var stationlist = [String: Any]()
    var stationelementTemp: String = ""
    var stationblank: Bool = false
    
    // TM_x, TM_y를 이용하여 근접 측정소 목록 api 호출
    func callStationListAPI(TM_x: Any, TM_y: Any) {
        let key = "Mj2lJctNluJLoMz0XV5F8XU0cGhTI2xNmVjB4fk%2BbojkGWq8%2F6PpOHbMVYrIKAxLQk8NgR7kPnJ%2BPD08HKqBEQ%3D%3D"
        let urlString = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getNearbyMsrstnList?tmX=\(TM_x)&tmY=\(TM_y)&ServiceKey=\(key)"
        
        guard let url = URL(string: urlString) else {
            NSLog("URL error!")
            return
        }
        guard let parser = XMLParser(contentsOf: url) else {
            NSLog("Failed Parsed with sationURL")
            return
        }
        
        parser.delegate = self
        if (parser.parse()){
            NSLog("stationURL parsed!!!!!!")
        }
        
    }
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        stationelementTemp = elementName
        stationblank = true
    }
    
    override func parser(_ parser: XMLParser, foundCharacters string: String) {
        if stationblank == true && stationelementTemp != "response" && stationelementTemp != "header" && stationelementTemp != "resultCode" && stationelementTemp != "resultMsg" && stationelementTemp != "body" {
            
            stationlist[stationelementTemp] = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        #if DEBUG
        print("string: \(string)")
        print("item: \(stationlist)")
        #endif
    }
    
    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            stationlists += [stationlist]
        }
        stationblank = false
        
        #if DEBUG
        print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ파싱 리스트 결과ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
        print("lists = \(stationlists)")
        #endif
        
    }
    
    // 측정소 stationName만 뽑아내기
    func extractStationName(_ data: Any?) -> Any? {
        guard let items = data as? [[String: Any]] else {
            return nil
        }
        var stationNames = [String]()
        // 측정소 3개
        for item in items {
            if let stationName = item["stationName"] as? String {
                stationNames.append(stationName)
                NSLog("stationNames = \(stationNames)")
            }
        }
        return stationNames
    }
    
}




