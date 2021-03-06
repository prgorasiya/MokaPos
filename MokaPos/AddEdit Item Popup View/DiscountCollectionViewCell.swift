//
//  DiscountCollectionViewCell.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


class DiscountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchApply: UISwitch!
    
    
    func updateCellWith(data: DiscountModel, applyDiscount: Bool) {
        let name = data.title.replacingOccurrences(of: "Discount ", with: "")
        self.titleLabel.text = String(format: "%@ (%.2f%%)", name, data.value)
        self.switchApply.setOn(applyDiscount, animated: false)
    }
}
