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
    
    var options: [OptionsModel] = []
    weak var delegate: OptionsViewModalDelegate?
    
    
    init(delegate: OptionsViewModalDelegate){
        self.delegate = delegate
    }
    
    
    func createOptionsModel() {
        let option1 = OptionsModel(title: "All Discounts", imageName: "1")
        let option2 = OptionsModel(title: "All Items", imageName: "2")
        options.append(option1)
        options.append(option2)
        self.delegate?.setOptions(data: options)
    }
}
