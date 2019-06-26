//
//  ViewController.swift
//  easi6-project
//
//  Created by Seoyoung on 24/06/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ViewController: UIViewController {

//    @IBOutlet weak var mapView: UIView!
//    @IBOutlet weak var tableView: UITableView!

    var mapView = UIView()
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = UITableViewCell.SeparatorStyle.none
        tv.allowsSelection = false
        return tv
    }()
    let cellName = "Cell"

    var myMapView: GMSMapView!
    var marker = GMSMarker()
    var geocoder: GMSGeocoder!
    var locationManager: CLLocationManager!

    var datalist = [LocationVO]()
    var locationData = LocationVO()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupView()

        tableView.reloadData()

        myMapView = GMSMapView(frame: mapView.frame)
        myMapView.clipsToBounds = true
        mapView.addSubview(myMapView)
        myMapView.isMyLocationEnabled = true

        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        // 위치추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 베터리로 동작할 때 권장되는 가장 높은 수준의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        geocoder = GMSGeocoder()
        self.myMapView.delegate = self
    }

    func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.rowHeight = 80
        self.tableView.register(ItemListCell.self, forCellReuseIdentifier: cellName)
    }

    func setupView() {
        self.view.addSubview(mapView)
        self.mapView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(self.view.snp.height).dividedBy(2)
        }
    }

    // 대기 질 marker 생성
    func fetchAirConditionMarkerLabel(latitude: Double, longitude: Double, zoom: Double) {
        let token = "3c48eb7b1e2c44825bdc0e9817e2a6504ea41694"
        let url = URL(string: "https://tiles.waqi.info/tiles/usepa-pm25/\(zoom)/\(latitude)/\(longitude).png?token=\(token)")
        
        do {
            let data = try Data(contentsOf: url!)
            let marker = GMSMarker()
            marker.icon = UIImage(data: data)
        } catch let error {
            NSLog("Error while fetching remote air condition marker labels : \(error)")
        }
    }
    // 대기 질, 상태 가져오기
    func fetchAirConditions(latitude: Double, longitude: Double) {
        let token = "3c48eb7b1e2c44825bdc0e9817e2a6504ea41694"
        let params = ["lat": latitude, "lng": longitude, "token": token] as [String : Any]

        guard let url = URL(string: "https://api.waqi.info/feed/geo:\(latitude);\(longitude)/?token=\(token)") else {
            return
        }

        Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: [:])
        .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let data = dic["data"] as! NSDictionary
                    let iaqi = data["iaqi"] as! NSDictionary
                    let pm25 = iaqi["pm25"] as! NSDictionary
                    let pm25v = pm25["v"] as! Int
                    self.locationData.pm25v = pm25v
                    self.locationData.condition = self.convertToString(value: pm25v)
                case .failure(let error):
                    NSLog("Error while fetching remote air conditions: \(error)")
                }
        }
    }
    // 추출한 데이터 -> 문자열로 변환
    func convertToString(value: Int) -> String {
        var result = ""

        switch value {
        case 0...50:
            result = "최고좋음"
        case 51...100:
            result = "좋음"
        case 101...150:
            result = "보통"
        case 151...200:
            result = "나쁨"
        case 201...300:
            result = "매우나쁨"
        case 301..<value:
            result = "최악"
        default:
            result = "정보없음"
            break
        }
        return result
    }

}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        getCurrentLocation(location.coordinate)
    }
    // 현재 위치 가져오기
    func getCurrentLocation(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else {
            return
        }
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        self.fetchAirConditions(latitude: latitude, longitude: longitude)
        self.fetchAirConditionMarkerLabel(latitude: latitude, longitude: longitude, zoom: 15.0)
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        myMapView.camera = camera
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = myMapView
    }

}

extension ViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        myMapView.clear()
    }
    // 지도 터치로 이동 시
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(position.target){ (response, error) in
            guard error == nil else {
                return
            }
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = position.target
                marker.title = "Location"
                marker.snippet = result.lines?[0]
                marker.map = self.myMapView

                self.locationData.location = "\(result.lines?[0] ?? "")"
                self.locationData.latitude = result.coordinate.latitude
                self.locationData.longitude = result.coordinate.longitude
                // 현재 위치 대기상태 데이터 가져오기
                self.fetchAirConditions(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                // 대기상태 마커라벨 찍기
                self.fetchAirConditionMarkerLabel(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude, zoom: 15.0)

                self.datalist.append(self.locationData)
                self.tableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ItemListCell
        cell.locationLabel.text = datalist[indexPath.row].location
        cell.pm25Label.text = "\(datalist[indexPath.row].pm25v)pm"
        cell.airConditionLabel.text = datalist[indexPath.row].condition
        return cell
    }
    // 셀 선택시 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = datalist[indexPath.row]
        let camera = GMSCameraPosition.camera(withLatitude: index.latitude, longitude: index.longitude, zoom: 15.0)
        myMapView.camera = camera
        marker.position = CLLocationCoordinate2D(latitude: index.latitude, longitude: index.longitude)
        marker.map = myMapView
        // 검색결과와 마커라벨을 모두 지운 후 선택한 셀을 검색결과 최상단으로 올린다.
        self.datalist.removeAll()
        myMapView.clear()
        tableView.reloadData()
    }

}
