//
//  Cart+CoreDataClass.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//
//

import Foundation
import CoreData


public class Cart: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, dict: [String: Any]) {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: moc) as! Cart
        newItem.productId = dict["productId"] as! Int64
        newItem.price = dict["price"] as! Double
        newItem.quantity = dict["quantity"] as! Int64
        newItem.discountId = dict["discountId"] as! Int64
        newItem.discountValue = dict["discountValue"] as! Double
        newItem.productName = dict["productName"] as? String
        do{
            try moc.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    class func createSubtotalEntryIn(moc: NSManagedObjectContext, value: Double) {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: moc) as! Cart
        newItem.productId = -1
        newItem.price = value
        newItem.quantity = 0
        newItem.discountId = 0
        newItem.discountValue = 0.0
        newItem.productName = "Subtotal"
        do{
            try moc.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    class func createDiscountEntryIn(moc: NSManagedObjectContext, value: Double) {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: moc) as! Cart
        newItem.productId = -2
        newItem.price = value
        newItem.quantity = 0
        newItem.discountId = 0
        newItem.discountValue = 0.0
        newItem.productName = "Discount"
        do{
            try moc.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    //delete object based on productId from Cart
    class func removeFromManagedObjectContext(moc: NSManagedObjectContext, productId: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId) // To fetch core data entity object from productId
        if let item = Cart.fetchFromManagedObjectContext(moc: moc, request: fetchRequest) {
            let objectToDelete = item[0]
            moc.delete(objectToDelete)
            do {
                try moc.save()
            }
            catch{
                print("Error deleting: \(error)")
            }
        }
    }
    
    
    //delete all objects from Cart entity
    class func deleteAllFrom(moc: NSManagedObjectContext) -> Bool{
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try moc.execute(deleteRequest)
            try moc.save()
            return true
        } catch {
            print ("There is an error in deleting records")
            return false
        }
    }
    
    
    // fetch and return item array if any with/without predicate
    class func fetchFromManagedObjectContext(moc: NSManagedObjectContext, request: NSFetchRequest<NSFetchRequestResult>) -> [Cart]? {
        do {
            if let results = try moc.fetch(request) as? [Cart] {
                return results.count == 0 ? nil : results
            }
        }
        catch{
            print("Error fetching: \(error)")
        }
        return nil
    }
}
