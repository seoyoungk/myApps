//
//  AirPollutionCell.swift
//  FIneDust
//
//  Created by Seoyoung on 30/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit

class AirPollutionCell: UICollectionViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!

    func setConditionImage() {
        var image: UIImage?
        switch self.conditionLabel.text ?? "" {
        case "좋음":
            image = UIImage(named: "01good.png")
        case "보통":
            image = UIImage(named: "02nomal.png")
        case "나쁨":
            image = UIImage(named: "03bad.png")
        case "매우나쁨":
            image = UIImage(named: "04sucks.png")
        case "정보없음":
            image = nil
        default: break
        }
        self.conditionImage.image = image
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
