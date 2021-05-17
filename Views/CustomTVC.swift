//
//  CustomTVC.swift
//  WeatherApp
//
//  Created by Farhana Khan on 17/05/21.
//

import UIKit

class CustomTVC: UITableViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var cityLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
