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
    
    
//    func createDiscountModels() {
//        //
//        // A check can be added here to check if value exists for allDiscounts and based on that save OR retrieve data from userdefaults
//        // but I haven't added it just to simply change discount value and see it reflect in cart
//        //
//        let discountA = DiscountModel(id: 1, title: "Discount A", value: 10)
//        let discountB = DiscountModel(id: 2, title: "Discount B", value: 35.5)
//        let discountC = DiscountModel(id: 3, title: "Discount C", value: 50)
//        let discountD = DiscountModel(id: 4, title: "Discount D", value: 100)
//        
//        var discounts: [DiscountModel] = [DiscountModel]()
//        discounts.append(discountA)
//        discounts.append(discountB)
//        discounts.append(discountC)
//        discounts.append(discountD)
//        
//        //To save the Discounts to userdefaults
//        UserDefaults.standard.save(customObject: discounts, inKey: StaticKeys.allDiscounts)
//        self.delegate?.setDiscounts(data: discounts)
//    }
}
