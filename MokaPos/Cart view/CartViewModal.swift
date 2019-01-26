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
    
    
    func addNewCartItem(dict: [String: Any]) {
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
    
    
    private func fetchItemWith(productId: Int) -> Item? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "id == %d", productId) //Fetching item from productId
        let results = Item.fetchFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        if results != nil {
            return results![0]
        }
        else{
            return nil
        }
    }
    
    
    func updateCartItemWith(productId: Int, quantity: Int, discountId: Int, updatedDiscountId: Int) {
        
        //Creating fetch request from productId and discountId
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d AND discountId == %d", productId, discountId)
        
        //Handling base case when quantity is 0 while adding/updating an item
        if quantity == 0 {
            Cart.removeFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
            self.calculateSubtotalAndDiscount()
            return
        }
        
        let allDiscounts: [DiscountModel] = UserDefaults.standard.retrieve(object: [DiscountModel].self, fromKey: StaticKeys.allDiscounts)!
        
        // To fetch core data entity object from productId and current discountId and update its values
        if let items = Cart.fetchFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest) {
            let itemToUpdate = items[0]
            itemToUpdate.quantity = Int64(quantity) + itemToUpdate.quantity
            if discountId > 0 {
                let discountToApply = allDiscounts.filter(){ $0.id == discountId }[0]
                itemToUpdate.discountId = Int64(updatedDiscountId)
                itemToUpdate.discountValue = discountToApply.value
            }
            do {
                try managedObjectContext.save()
                self.calculateSubtotalAndDiscount()
            }
            catch {
                print("Could not save. \(error)")
            }
        }
        else {
            if let item = self.fetchItemWith(productId: productId) {
                var itemDict: [String: Any] = ["productId": Int64(productId), "price": item.price, "quantity": Int64(quantity), "productName": item.title!]
                if discountId > 0 {
                    let discountToApply = allDiscounts.filter(){ $0.id == discountId }[0]
                    itemDict["discountId"] = Int64(discountId)
                    itemDict["discountValue"] = discountToApply.value
                }
                self.addNewCartItem(dict: itemDict)
                self.calculateSubtotalAndDiscount()
            }
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
            self.fetchCartItems()
        }
    }
    
    
    private func updateSubtotalEntry(amount: Double) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d", -1)
        Cart.removeFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        Cart.createSubtotalEntryIn(moc: managedObjectContext, value: amount)
    }
    
    
    private func updateDiscountEntry(amount: Double) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d", -2)
        Cart.removeFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        Cart.createDiscountEntryIn(moc: managedObjectContext, value: amount)
    }
}
