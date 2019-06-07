//
//  SearchLocationVC.swift
//  FIneDust
//
//  Created by Seoyoung on 05/06/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import Alamofire

class SearchLocationVC: UITableViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    var tmX = [String]()
    var tmY = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocationFromMapAPI()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }

    func getCurrentLocationFromMapAPI() {

        let param: Parameters = [:]
        let urlString = "https://dapi.kakao.com/v2/local/search/address.json?query=서울시 강남구 삼성동"
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url = URL(string: encoded) else {
            NSLog("parsing error!")
            return
        }
        
        Alamofire.request(url, method: .get, parameters: param, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": "KakaoAK 24e93a6eead4d50435fec4c48ce3603e"])
        .validate().responseJSON { response in
            guard response.result.isSuccess else {
                NSLog("Error while fetching remote: \(String(describing: response.result.error))")
                return
            }

            guard let value = response.result.value as? [String: Any],
                let document = value["document"] as? NSArray else {
                    NSLog("document error")
                    return
            }
            #if DEBUG
            print("document = \(document)")
            #endif
            for index in 0...(document.count - 1) {
                let documents = document[index] as? NSDictionary ?? ["":""]
                self.tmX.append(documents["x"] as? String ?? "")
                self.tmY.append(documents["y"] as? String ?? "")
            }
            NSLog("tmX = \(self.tmX), tmY = \(self.tmY)")
        }

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
//func getCurrentLocationFromMapAPI() {
//    let urlString = "https://dapi.kakao.com/v2/local/search/address.json?query=서울시 강남구 삼성동"
//
//    guard let url = URL(string: urlString) else {
//        NSLog("parsing error!")
//        return
//    }
//
//    Alamofire.request(url, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": "KakaoAK 24e93a6eead4d50435fec4c48ce3603e"])
//        .validate().responseJSON{ response in
//            guard response.result.isSuccess else {
//                NSLog("Error while fetching remote: \(String(describing: response.result.error))")
//                return
//            }
//            let data = try! Data(contentsOf: url)
//            NSLog("data : \(data)")
//            let result = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//            NSLog("result = \(result)")
//
//            let document = result["documents"] as! NSArray
//            for index in 0...(document.count - 1) {
//                let documents = document[index] as! NSDictionary
//                self.tmX.append(documents["x"] as! String)
//                self.tmY.append(documents["y"] as! String)
//            }
//            NSLog("tmX = \(self.tmX), tmY = \(self.tmY)")
//    }
//}
