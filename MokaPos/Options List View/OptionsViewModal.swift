//
//  OptionsViewModal.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation

protocol OptionsViewModalDelegate: class {
    func setOptions(data: [OptionsModel])
}


class OptionsViewModal: NSObject {
    
    static let discountTitle: String = "All Discounts"
    static let listTitle: String = "All Items"
    
    static let discountImageName: String = "discount"
    static let listImageName: String = "list"
    
    var options: [OptionsModel] = []
    weak var delegate: OptionsViewModalDelegate?
    
    
    init(delegate: OptionsViewModalDelegate){
        self.delegate = delegate
    }
    
    
    //Creating options model array and setting to view
    func createOptionsModel() {
        let option1 = OptionsModel(title: OptionsViewModal.discountTitle, imageName: OptionsViewModal.discountImageName)
        let option2 = OptionsModel(title: OptionsViewModal.listTitle, imageName: OptionsViewModal.listImageName)
        options.append(option1)
        options.append(option2)
        self.delegate?.setOptions(data: options)
    }
    
    
    //Creating discount models
    func createDiscountModels() -> [DiscountModel] {
        //
        // A check can be added here to check if value exists for allDiscounts and based on that save OR retrieve data from userdefaults
        // but I haven't added it just to simply change discount value and see it reflect in cart
        //
        //discountId = 0 means no discount that's why here it starts from 0 and it is maintained throughout the project
        let discountA = DiscountModel(id: 1, title: "Discount A", value: 10)
        let discountB = DiscountModel(id: 2, title: "Discount B", value: 35.5)
        let discountC = DiscountModel(id: 3, title: "Discount C", value: 50)
        let discountD = DiscountModel(id: 4, title: "Discount D", value: 100)
        
        var discounts: [DiscountModel] = [DiscountModel]()
        discounts.append(discountA)
        discounts.append(discountB)
        discounts.append(discountC)
        discounts.append(discountD)
        return discounts
    }
    
    
    //Strogin discount models to userdefaults after archieving
    func saveDiscountModelsLocally() {
        let discounts = self.createDiscountModels()
        //To save the Discounts to userdefaults
        UserDefaults.standard.save(customObject: discounts, inKey: StaticKeys.allDiscounts)
    }
}
