//
//  ItemTableViewCell.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    func updateCellWith(data: Item) {
        self.imageVw.loadImageUsingCache(withUrl: data.thumbnail)
        self.title.text = data.title
        self.price.text = String(format: "$%.1f", data.price)
    }
}
