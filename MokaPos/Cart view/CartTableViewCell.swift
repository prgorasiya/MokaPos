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
        if data.quantity > 0 {
            self.quantity.text = String(format: "x%d", data.quantity)
            self.quantity.isHidden = false
        }
        else{
            self.quantity.isHidden = true
        }
        
        //Showing actual product data
        if data.productId > 0 {
            self.price.text = String(format: "$%.1f", data.price * Double(data.quantity))
        }
        else {
            self.price.text = String(format: "$%.1f", data.price) //Showing subtotal and discount
        }
    }
}
