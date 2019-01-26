//
//  Item+CoreDataClass.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    class func createFrom(json: [String: Any]) {
        let backgroundContext = MyDelegate.appDelegate.backgroundContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: backgroundContext) as! Item
        newItem.id = json["id"] as! Int64
        newItem.thumbnail = json["thumbnailUrl"] as? String
        newItem.title = json["title"] as? String
        newItem.price = Double(newItem.id) * Double(Int.random(in: 10...99))
        do{
            try backgroundContext.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    //delete all objects from Cart entity
    class func deleteAll() -> Bool {
        let backgroundContext = MyDelegate.appDelegate.backgroundContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
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
    class func fetchFor(request: NSFetchRequest<NSFetchRequestResult>) -> [Item]? {
        let mainContext = MyDelegate.appDelegate.persistentContainer.viewContext
        do {
            if let results = try mainContext.fetch(request) as? [Item] {
                return results.count == 0 ? nil : results
            }
        }
        catch{
            print("Error fetching: \(error)")
        }
        return nil
    }
}
