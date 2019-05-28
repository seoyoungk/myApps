//
//  ExtensionCollectionViewController.swift
//  TodayRecipe
//
//  Created by Seoyoung on 26/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import Foundation

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
