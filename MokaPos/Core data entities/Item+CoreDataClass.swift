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
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, json: [String: Any]) {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: moc) as! Item
        newItem.id = json["id"] as! Int64
        newItem.thumbnail = json["thumbnailUrl"] as? String
        newItem.title = json["title"] as? String
        newItem.price = Double(newItem.id) * Double(Int.random(in: 10...99))
        do{
            try moc.save()
        }
        catch {
            print("Could not save. \(error)")
        }
    }
    
    
    // fetch and return item array if any with/without predicate
    class func fetchFromManagedObjectContext(moc: NSManagedObjectContext, request: NSFetchRequest<NSFetchRequestResult>) -> [Item]? {
        do {
            if let results = try moc.fetch(request) as? [Item] {
                return results.count == 0 ? nil : results
            }
        }
        catch{
            print("Error fetching: \(error)")
        }
        return nil
    }
}
