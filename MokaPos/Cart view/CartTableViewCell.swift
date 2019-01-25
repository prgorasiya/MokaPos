//
//  CartTableViewCell.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    func updateCellWith(data: Cart) {
        self.title.text = data.productName
        self.quantity.text = String(data.quantity)
        self.price.text = String(format: "$%.1f", data.price * Double(data.quantity))
    }
}
