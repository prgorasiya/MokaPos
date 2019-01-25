//
//  AddEditItemPopupView.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


class AddEditItemPopupView: UIViewController {
    
    var productId: Int!
    var quantity: Int?
    var discountId: Int?
    
    var item: Item?
    var viewModal: AddEditPopupViewModal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.viewModal = AddEditPopupViewModal(delegate: self)
        self.viewModal?.fetchItemFromDatabase(productId: productId)
    }
    
    
    func showAnimated() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    func removeAnimated() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
}


extension AddEditItemPopupView: AddEditPopupModalDelegate {
    func setItem(data: Item) {
        self.item = data
    }
}
