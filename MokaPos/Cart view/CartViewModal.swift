//
//  CartViewModal.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import CoreData

protocol CartViewModalDelegate: class {
    func setCartItems(data: [Cart])
    func setEmptyCart()
}


class CartViewModal: NSObject {
    
    weak var delegate: CartViewModalDelegate?
    let managedObjectContext = MyDelegate.appDelegate.persistentContainer.viewContext
    
    
    init(delegate: CartViewModalDelegate){
        self.delegate = delegate
    }
    
    
    func fetchCartItems() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let results = Cart.fetchFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        if results != nil {
            self.delegate?.setCartItems(data: results!)
        }
        else{
            self.delegate?.setEmptyCart()
        }
    }
}
