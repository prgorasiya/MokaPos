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
    
    weak var delegate: DiscountListModalDelegate?
    
    
    init(delegate: DiscountListModalDelegate){
        self.delegate = delegate
    }
    
    
    func getDiscountList() {
        let discounts = UserDefaults.standard.retrieve(object: [DiscountModel].self, fromKey: StaticKeys.allDiscounts)!
        self.delegate?.setDiscounts(data: discounts)
    }
}
