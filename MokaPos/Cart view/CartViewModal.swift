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
    
    
    func createCartItem(dict: [String: Any]) {
        Cart.createInManagedObjectContext(moc: managedObjectContext, dict: dict)
        self.fetchCartItems()
    }
    
    
    func fetchCartItems() {
        let results = self.fetchCartItemsFromDatabase()
        if results != nil {
            self.delegate?.setCartItems(data: results!)
        }
        else{
            self.delegate?.setEmptyCart()
        }
    }
    
    
    func fetchCartItemsFromDatabase() -> [Cart]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let results = Cart.fetchFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        if results != nil {
            return results
        }
        else{
            return nil
        }
    }
    
    
    func emptyCart() {
        if Cart.deleteAllFrom(moc: managedObjectContext) {
            self.delegate?.setEmptyCart()
        }
    }
    
    
    func calculateSubtotalAndDiscount() {
        let results = self.fetchCartItemsFromDatabase()
        if results != nil {
            var subtotal = 0.0
            var totalDiscount = 0.0
            for cart in results! {
                if cart.productId != -1 || cart.productId != -2 { // Don't consider subtotal and discount entries from array
                    subtotal += cart.price * Double(cart.quantity)
                    if cart.discountId > 0 {
                        totalDiscount += (cart.price * Double(cart.quantity)) * (cart.discountValue/100.0) //Calculate total discount among all products
                    }
                }
            }
            self.updateSubtotalEntry(amount: subtotal)
            self.updateDiscountEntry(amount: totalDiscount)
        }
    }
    
    
    private func updateSubtotalEntry(amount: Double) {
        Cart.removeFromManagedObjectContext(moc: managedObjectContext, productId: -1)
        Cart.createSubtotalEntryIn(moc: managedObjectContext, value: amount)
    }
    
    
    private func updateDiscountEntry(amount: Double) {
        Cart.removeFromManagedObjectContext(moc: managedObjectContext, productId: -2)
        Cart.createDiscountEntryIn(moc: managedObjectContext, value: amount)
    }
}
