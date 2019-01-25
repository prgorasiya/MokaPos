//
//  DiscountListViewModal.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation


protocol DiscountListModalDelegate: class {
    func setDiscounts(data: [DiscountModel])
}


class DiscountListViewModal: NSObject {
    
    var discounts: [DiscountModel] = []
    weak var delegate: DiscountListModalDelegate?
    
    
    init(delegate: DiscountListModalDelegate){
        self.delegate = delegate
    }
    
    
    func createDiscountModels() {
        let discountA = DiscountModel(id: 1, title: "Discount A", value: 10)
        let discountB = DiscountModel(id: 2, title: "Discount B", value: 35.5)
        let discountC = DiscountModel(id: 3, title: "Discount C", value: 50)
        let discountD = DiscountModel(id: 4, title: "Discount D", value: 100)
        
        discounts.append(discountA)
        discounts.append(discountB)
        discounts.append(discountC)
        discounts.append(discountD)
        self.delegate?.setDiscounts(data: discounts)
    }
}
