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

        let param: Parameters = ["query": "강남구"]
        let urlString = "https://dapi.kakao.com/v2/local/search/address.json"
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url = URL(string: encoded) else {
            NSLog("parsing error!")
            return
        }

        Alamofire.request(url, method: .get, parameters: param, encoding: JSONEncoding.default, headers: ["Authorization": "KakaoAK 07563fdd6fec79279c07ee88d930f118"])
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
