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
    
    
    func createOptionsModel() {
        let option1 = OptionsModel(title: OptionsViewModal.discountTitle, imageName: OptionsViewModal.discountImageName)
        let option2 = OptionsModel(title: OptionsViewModal.listTitle, imageName: OptionsViewModal.listImageName)
        options.append(option1)
        options.append(option2)
        self.delegate?.setOptions(data: options)
    }
}
