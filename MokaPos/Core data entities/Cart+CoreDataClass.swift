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
