//
//  LocationData.swift
//  TodayRecipe
//
//  Created by Seoyoung on 27/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation
import CoreData

class LocationData: XMLParser, XMLParserDelegate {
    let locationVO = LocationVO()
    
    var lists = [[String: Any]]()
    var list = [String: Any]()
    var elementTemp: String = ""
    var blank: Bool = false
    
    
    func stationListURL(TM_x: Any, TM_y: Any) {
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
        
//    }
    
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
        print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ파싱 리스트 결과ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
        print("lists = \(lists)")
        #endif
        
    }

  }
    
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




