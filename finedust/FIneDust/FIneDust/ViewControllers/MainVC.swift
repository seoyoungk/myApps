//
//  ViewController.swift
//  FIneDust
//
//  Created by Seoyoung on 30/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, XMLParserDelegate {

    @IBOutlet weak var currentConditionImage: UIImageView!
    @IBOutlet weak var currentStationLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchButton: UIButton!

    var airPollutionData = AirPollutionData()
    var airPollutionCount = 6

    var lists = [[String: Any]]()
    var list = [String: Any]()
    var elementTemp: String = ""
    var blank: Bool = false

    // locationData 선언  -> extension에서 값 저장해줌
    let locationData = LocationVO.sharedInstance

    var locationManager: CLLocationManager!
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.isHidden = true
        // refreshControl / 당겨서 새로 고침
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor(red: 51, green: 124, blue: 130, alpha: 1.0)

        // refreshControl 액션에 대한 행위 정의
        refreshControl?.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)

        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl!)
        }

        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self
        // 미세먼지 API를 호출

        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        // 위치추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 베터리로 동작할 때 권장되는 가장 높은 수준의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    // refreshControl 액션
    @objc func pullToRefresh() {
        locationManager.startUpdatingLocation()
        timeUpdate()
        if let refreshControl = refreshControl {
            refreshControl.endRefreshing()
        }
        // locationManager()
    }

    // 미세먼지 API를 호출하는 메소드
    func callAirAPI(result: String = "") {
        // func cellAirAPI(data: Any){
        let key = "Mj2lJctNluJLoMz0XV5F8XU0cGhTI2xNmVjB4fk%2BbojkGWq8%2F6PpOHbMVYrIKAxLQk8NgR7kPnJ%2BPD08HKqBEQ%3D%3D"
        let urlString = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=\(result)&dataTerm=month&pageNo=1&numOfRows=10&ServiceKey="

        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + key

        guard let url = URL(string: encoded) else {
            #if DEBUG
            print("URL error!")
            #endif
            return
        }
        guard let parser = XMLParser(contentsOf: url) else {
            return
        }

        parser.delegate = self

        if parser.parse() {
            #if DEBUG
            print("Successfully Parsed")
            #endif
        } else {
            let alert = UIAlertController(title: "Error", message: "Parsing failed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: false)
        }
    }
    // xml parser
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        elementTemp = elementName
        blank = true
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if blank == true && elementTemp != "response" && elementTemp != "header" && elementTemp != "body" {
            // elementTemp != "resultCode" && elementTemp != "resultMsg" &&
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
        // api 호출 실패 시 해당 error message를 경고창으로 띄움
        if let resultCode = list["resultCode"] as? String, resultCode != "00",
            let resultMsg = list["resultMsg"] as? String {
            let alert = UIAlertController(title: "Error", message: "Parsing failed: \(resultMsg)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: false)
        }

        #if DEBUG
        print("end: \(elementName)")
        print("---------------------------------------")
        print("lists = \(lists)")
        #endif

        // 현재 대기상태 label 업데이트
        self.currentConditionLabel.text = airPollutionData.getCurrentData(lists)?.khaiGrade ?? ""
        self.conditionImageUpdate(airPollutionData.getCurrentData(lists)?.khaiGrade ?? "")
        self.timeUpdate()
        self.collectionView.reloadData()
    }

    private func conditionImageUpdate(_ status: String) {
        // 현재 대기상태 image 업데이트
        var image: UIImage?
        switch status {
        case "좋음":
            image = UIImage(named: "01good.png")
            self.view.backgroundColor = UIColor(hex: 0x15D4F4)
        case "보통":
            image = UIImage(named: "02nomal.png")
            self.view.backgroundColor = UIColor(hex: 0x01A651)
        case "나쁨":
            image = UIImage(named: "03bad.png")
            self.view.backgroundColor = UIColor(hex: 0xF4AC55)
        case "매우나쁨":
            image = UIImage(named: "04sucks.png")
            self.view.backgroundColor = UIColor(hex: 0xED3F22)
        default:
            break
        }
        currentConditionImage.image = image
    }

    private func timeUpdate() {
        // 현재 시각
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        currentTimeLabel.text = dateFormatter.string(from: date)
    }

}

extension MainVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordi = manager.location?.coordinate {
            let latitude = coordi.latitude
            let longtitude = coordi.longitude
            // locationData에 위도, 경도 정보 넣기
            locationData.latitude = latitude
            locationData.longtitude = longtitude

            if locationData.latitude != 0.0 && locationData.longtitude != 0.0 {
                // 위도, 경도를 tmX, tmY로 변환 후 근접 측정소 목록 뽑아온다
                let currentStation = CurrentStationName()
                currentStation.getTM {
                    // 현재 위치 label에 넣는다
                    let result = currentStation.locationVO.stationLists.first
                    if let result = result {
                        self.callAirAPI(result: result)
                        self.currentStationLabel.text = "측정소 : \(result)"
                        self.currentLocationLabel.text = currentStation.locationVO.location
                        self.collectionView.reloadData()
                        self.locationManager.stopUpdatingLocation()
                    } else {
                        self.currentStationLabel.text = ""
                    }
                }
            }
        }
    }

}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return airPollutionCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return airPollutionCell(indexPath: indexPath)
    }

}

extension MainVC {

    private func airPollutionCell(indexPath: IndexPath) -> AirPollutionCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AirPollutionCell else {
            return AirPollutionCell()
        }
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
        cell.setConditionImage()
        return cell
    }

}

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}
