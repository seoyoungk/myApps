//
//  AirData.swift
//  TodayRecipe
//
//  Created by Seoyoung on 24/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation

class AirPollutionData {
    
    enum TypeCategory {
        case dataTime, khaiValue, pm10Value, no2Value, coValue, o3Value, so2Value, khaiGrade, so2Grade, coGrade, o3Grade, no2Grade, pm10Grade
    }
    
    func currentData(_ data: Any) -> AirPollutionVO? {
        guard let items = data as? [[String: Any]],
            let item = items.first else {
                return nil
        }
        
        var airPollution = AirPollutionVO()
        
        for (key, value) in item {
            switch key {
            case "dataTime":
                airPollution.dataTime = convertToString(.dataTime, value: value)
            case "pm10Value":
                airPollution.pm10Value = convertToString(.pm10Value, value: value)
            case "so2Value":
                airPollution.so2Value = convertToString(.so2Value, value: value)
            case "coValue":
                airPollution.coValue = convertToString(.coValue, value: value)
            case "o3Value":
                airPollution.o3Value = convertToString(.o3Value, value: value)
            case "no2Value":
                airPollution.no2Value = convertToString(.no2Value, value: value)
            case "khaiValue":
                airPollution.khaiValue = convertToString(.khaiValue, value: value)
            case "khaiGrade":
                airPollution.khaiGrade = convertToString(.khaiGrade, value: value)
            case "pm10Grade":
                airPollution.pm10Grade = convertToString(.pm10Grade, value: value)
            case "so2Grade":
                airPollution.so2Grade = convertToString(.so2Grade, value: value)
            case "coGrade":
                airPollution.coGrade = convertToString(.coGrade, value: value)
            case "o3Grade":
                airPollution.o3Grade = convertToString(.o3Grade, value: value)
            case "no2Grade":
                airPollution.no2Grade = convertToString(.no2Grade, value: value)
            default: break
            }
        }
        return airPollution
    }
    
    // 추출한 데이터 -> 문자열로 변환
    private func convertToString(_ type: TypeCategory, value: Any) -> String {
        var result = ""
        
        switch type {
        case .dataTime, .khaiValue:
            result = "\(value)"
        case .so2Value, .coValue, .o3Value, .no2Value:
            result = ("\(value)" == "-") ? "-" : "\(value)ppm"
        case .pm10Value:
            result = ("\(value)" == "-") ? "-" : "\(value)㎍/㎥"
        case .khaiGrade, .so2Grade, .coGrade, .o3Grade, .no2Grade, .pm10Grade:
            let grade = "\(value)"
            
            if grade == "1" {
                result = "좋음"
            } else if grade == "2" {
                result = "보통"
            } else if grade == "3" {
                result = "나쁨"
            } else if grade == "4" {
                result = "매우나쁨"
            } else {
                result = "정보없음"
            }
        }
        return result
    }
}

