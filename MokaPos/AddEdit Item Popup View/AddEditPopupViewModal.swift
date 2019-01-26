//
//  AddEditPopupViewModal.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import CoreData

protocol AddEditPopupModalDelegate: class {
    func setItem(data: Item)
}


class AddEditPopupViewModal: NSObject {
    
    weak var delegate: AddEditPopupModalDelegate?
    let managedObjectContext = MyDelegate.appDelegate.persistentContainer.viewContext
    
    
    init(delegate: AddEditPopupModalDelegate){
        self.delegate = delegate
    }
    
    
    func fetchItemFromDatabase(productId: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "id == %d", productId)
        if let items = Item.fetchFor(request: fetchRequest) {
            self.delegate?.setItem(data: items[0])
        }
    }
}
