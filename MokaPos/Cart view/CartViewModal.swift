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
    func setTotalPriceToCharge(amount: Double)
    func setEmptyCart()
}


class CartViewModal: NSObject {
    
    weak var delegate: CartViewModalDelegate?
    let managedObjectContext = MyDelegate.appDelegate.persistentContainer.viewContext
    let allDiscounts: [DiscountModel] = UserDefaults.standard.retrieve(object: [DiscountModel].self, fromKey: StaticKeys.allDiscounts)!
    
    init(delegate: CartViewModalDelegate){
        self.delegate = delegate
    }
    
    
    //MARK: Fetch methods
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
        let results = Cart.fetchFor(request: fetchRequest)
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
        let results = Item.fetchFor(request: fetchRequest)
        if results != nil {
            return results![0]
        }
        else{
            return nil
        }
    }
    
    
    //MARK: Add methods
    func addNewCartItem(dict: [String: Any]) {
        Cart.createFrom(dict: dict)
        self.fetchCartItems()
    }
    
    
    func addToCartWith(productId: Int, quantity: Int, discountId: Int, updatedDiscountId: Int) {
        self.updateCartItemWith(productId: productId, quantity: quantity, discountId: discountId, updatedDiscountId: updatedDiscountId, isUpdate: false)
    }

    
    //MARK: Update methods
    func updateToCartWith(productId: Int, quantity: Int, discountId: Int, updatedDiscountId: Int) {
        self.updateCartItemWith(productId: productId, quantity: quantity, discountId: discountId, updatedDiscountId: updatedDiscountId, isUpdate: true)
    }
    
    
    func updateCartItemWith(productId: Int, quantity: Int, discountId: Int, updatedDiscountId: Int, isUpdate: Bool) {
        
        //Creating fetch request from productId and discountId
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d AND discountId == %d", productId, discountId)
        
        //Handling base case when quantity is 0 while adding/updating an item
        if quantity == 0 {
            Cart.removeFor(request: fetchRequest)
            self.calculateSubtotalAndDiscount()
            return
        }
        
        // To fetch core data entity object from productId and current discountId and update its values
        if let items = Cart.fetchFor(request: fetchRequest) {
            let itemToUpdate = items[0]
            if isUpdate {
                itemToUpdate.quantity = Int64(quantity)
            }
            else{
                itemToUpdate.quantity = Int64(quantity) + itemToUpdate.quantity
            }
            if updatedDiscountId > 0 {
                let discountToApply = allDiscounts.filter(){ $0.id == updatedDiscountId }[0]
                itemToUpdate.discountId = Int64(updatedDiscountId)
                itemToUpdate.discountValue = discountToApply.value
            }
            else{
                itemToUpdate.discountId = 0
                itemToUpdate.discountValue = 0
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
    
    
    //MARK: Delete method
    func emptyCart() {
        if Cart.deleteAll() {
            self.delegate?.setTotalPriceToCharge(amount: 0)
            self.delegate?.setEmptyCart()
        }
    }
    
    
    //MARK: Subtotal and discount calculation methods
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
            
            if subtotal == 0{
                self.emptyCart()
                return
            }
            self.delegate?.setTotalPriceToCharge(amount: subtotal - totalDiscount)
            self.updateSubtotalEntry(amount: subtotal)
            self.updateDiscountEntry(amount: totalDiscount)
            self.fetchCartItems()
        }
    }
    
    
    private func updateSubtotalEntry(amount: Double) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d", -1)
        Cart.removeFor(request: fetchRequest)
        Cart.createSubtotalEntryFor(value: amount)
    }
    
    
    private func updateDiscountEntry(amount: Double) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d", -2)
        Cart.removeFor(request: fetchRequest)
        Cart.createDiscountEntryFor(value: amount)
    }
}
