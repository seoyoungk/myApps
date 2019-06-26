//
//  ItemListCell.swift
//  easi6-project
//
//  Created by Seoyoung on 24/06/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import SnapKit

class ItemListCell: UITableViewCell {

//    @IBOutlet weak var currentLabel: UILabel!
//    @IBOutlet weak var airConditionLabel: UILabel!
//    @IBOutlet weak var currentConditionLabel: UILabel!

    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gill Sans SemiBold", size: 15)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var pm25Label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gill Sans", size: 17)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var currentConditionLabel: UILabel = {
        let label = UILabel()
        label.text = "미세먼지: "
        label.font = UIFont(name: "Gill Sans", size: 17)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var airConditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gill Sans", size: 17)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    func setup() {
        addSubview(cellView)
        cellView.addSubview(locationLabel)
        cellView.addSubview(currentConditionLabel)
        cellView.addSubview(airConditionLabel)
        cellView.addSubview(pm25Label)

        cellView.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(self.snp.height)
        }

        locationLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.cellView.snp.top).offset(10)
            make.trailing.equalTo(self.cellView.snp.trailing).offset(15)
            make.leading.equalTo(self.cellView.snp.leading).offset(15)
            make.bottom.equalTo(self.airConditionLabel.snp.top).offset(15.5)
            make.bottom.equalTo(self.pm25Label.snp.top).offset(15.5)
        }

        currentConditionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.cellView.snp.leading).offset(45)
            make.bottom.equalTo(self.cellView.snp.bottom)
            make.trailing.equalTo(self.airConditionLabel.snp.leading).offset(10)
        }

        airConditionLabel.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.cellView.snp.bottom)
            make.trailing.lessThanOrEqualTo(self.pm25Label.snp.leading).offset(40)
            make.leading.equalTo(self.currentConditionLabel.snp.trailing).offset(10)
            make.top.equalTo(self.locationLabel.snp.bottom).offset(15.5)
        }

        pm25Label.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.cellView.snp.bottom)
            make.top.equalTo(self.locationLabel.snp.bottom).offset(15.5)
            make.trailing.lessThanOrEqualTo(self.cellView.snp.trailing).offset(82)
            make.leading.lessThanOrEqualTo(self.airConditionLabel.snp.trailing).offset(40)
        }

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
