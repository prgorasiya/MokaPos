//
//  DiscountCollectionViewCell.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


protocol DiscountCollectionViewCellDelegate: class {
    func switchValueDidChangeAt(index: Int)
}


class DiscountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchApply: UISwitch!
    
    weak var delegate: DiscountCollectionViewCellDelegate?
    
    
    func updateCellWith(data: DiscountModel, applyDiscount: Bool) {
        let name = data.title.replacingOccurrences(of: "Discount ", with: "")
        self.titleLabel.text = String(format: "%@ (%.2f%%)", name, data.value)
        self.switchApply.isOn = applyDiscount
        self.switchApply.tag = data.id
    }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.delegate?.switchValueDidChangeAt(index: sender.tag)
        }
        else{
            self.delegate?.switchValueDidChangeAt(index: 0)
        }
    }
}
