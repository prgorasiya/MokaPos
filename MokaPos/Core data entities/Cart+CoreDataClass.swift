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

    //Create Cart item from fetchRequest
    class func createFrom(dict: [String: Any]) {
        let backgroundContext = MyDelegate.appDelegate.backgroundContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: backgroundContext) as! Cart
        newItem.productId = dict["productId"] as! Int64
        newItem.price = dict["price"] as! Double
        newItem.quantity = dict["quantity"] as! Int64
        if let discountId = dict["discountId"] {
            newItem.discountId = discountId as! Int64
        }
        if let discountValue = dict["discountValue"] {
            newItem.discountValue = discountValue as! Double
        }
        newItem.productName = dict["productName"] as? String
        do{
            try backgroundContext.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    //Add subtotal object to Cart table
    class func createSubtotalEntryFor(value: Double) {
        let backgroundContext = MyDelegate.appDelegate.backgroundContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: backgroundContext) as! Cart
        newItem.productId = -1
        newItem.price = value
        newItem.quantity = 0
        newItem.discountId = 0
        newItem.discountValue = Double(0)
        newItem.productName = "Subtotal"
        do{
            try backgroundContext.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    //Add discount object to Cart table
    class func createDiscountEntryFor(value: Double) {
        let backgroundContext = MyDelegate.appDelegate.backgroundContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: backgroundContext) as! Cart
        newItem.productId = -2
        newItem.price = value
        newItem.quantity = 0
        newItem.discountId = 0
        newItem.discountValue = Double(0)
        newItem.productName = "Discount"
        do{
            try backgroundContext.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    //delete object based on productId from Cart
    class func removeFor(request: NSFetchRequest<NSFetchRequestResult>) {
        let mainContext = MyDelegate.appDelegate.persistentContainer.viewContext
        if let item = Cart.fetchFor(request: request) {
            let objectToDelete = item[0]
            mainContext.delete(objectToDelete)
            do {
                try mainContext.save()
            }
            catch{
                print("Error deleting: \(error)")
            }
        }
    }
    
    
    //delete all objects from Cart entity
    class func deleteAll() -> Bool{
        let backgroundContext = MyDelegate.appDelegate.backgroundContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try backgroundContext.execute(deleteRequest)
            try backgroundContext.save()
            return true
        }
        catch {
            print ("There is an error in deleting records")
            return false
        }
    }
    
    
    // fetch and return item array if any with/without predicate
    class func fetchFor(request: NSFetchRequest<NSFetchRequestResult>) -> [Cart]? {
        let mainContext = MyDelegate.appDelegate.persistentContainer.viewContext
        do {
            if let results = try mainContext.fetch(request) as? [Cart] {
                return results.count == 0 ? nil : results
            }
        }
        catch{
            print("Error fetching: \(error)")
        }
        return nil
    }
}
