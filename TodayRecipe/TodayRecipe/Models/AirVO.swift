//
//  AirVO.swift
//  TodayRecipe
//
//  Created by Seoyoung on 23/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation

struct AirPollutionVO {
    var dataTime: String? // 측정시간
    
    var khaiValue: String? // 통합대기환경수치
    var pm10Value: String? // 미세먼지 농도
    var no2Value: String? // 이산화질소 농도
    var coValue: String? // 일산화탄소 농도
    var o3Value: String? // 오존 농도
    var so2Value: String? // 아황산가스 농도
    
    var khaiGrade: String? // 통합대기환경지수
    var so2Grade: String? // 아황산가스 지수
    var coGrade: String? // 일산화탄소 지수
    var o3Grade: String? // 오존 지수
    var no2Grade: String? // 이산화질소 지수
    var pm10Grade: String? // 미세먼지 24시간 등급
    
    
//    init(dataTime: String, khaiValue: String, khaiGrade: String, pm10Value: String, no2Value: String, coValue: String, o3Value: String, so2Value: String, so2Grade: String, coGrade: String, o3Grade: String, no2Grade: String, pm10Grade: String) {
//
//        self.dataTime = dataTime
//
//        self.khaiValue = khaiValue
//        self.khaiGrade = khaiGrade
//        self.pm10Value = pm10Value
//        self.no2Value = no2Value
//        self.coValue = coValue
//        self.o3Value = o3Value
//        self.so2Value = so2Value
//
//        self.so2Grade = so2Grade
//        self.coGrade = coGrade
//        self.o3Grade = o3Grade
//        self.no2Grade = no2Grade
//        self.pm10Grade = pm10Grade
//    }
}
