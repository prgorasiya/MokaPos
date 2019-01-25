//
//  Cart+CoreDataProperties.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var productId: Int64
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int64
    @NSManaged public var discountId: Int64
    @NSManaged public var discountValue: Double
    @NSManaged public var productName: String?

}
