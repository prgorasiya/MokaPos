//
//  ItemListViewModal.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import CoreData


protocol ItemListViewModalDelegate: class {
    func startLoading()
    func finishLoading()
    func setItems(data: [Item])
    func setEmptyItems()
}


class ItemListViewModal: NSObject {
    
    fileprivate let service: ItemListService
    weak var delegate: ItemListViewModalDelegate?
    let managedObjectContext = MyDelegate.appDelegate.persistentContainer.viewContext
    
    init(service: ItemListService, delegate: ItemListViewModalDelegate){
        self.service = service
        self.delegate = delegate
    }
    
    
    func fetchAllItems() {
        self.delegate?.startLoading()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let results = Item.fetchFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        if results != nil {
            self.delegate?.finishLoading()
            self.delegate?.setItems(data: results!)
        }
        else{
            self.service.getItemsData { (response) in
                if let data = response {
                    if self.saveInCoreDataWith(array: data) {
                        self.fetchAllItems()
                    }
                }
                else{
                    self.delegate?.finishLoading()
                    self.delegate?.setEmptyItems()
                }
            }
        }
    }
    
    
    private func saveInCoreDataWith(array: [[String: Any]]) -> Bool {
        _ = array.map{Item.createInManagedObjectContext(moc: managedObjectContext, json: $0)}
        do {
            try managedObjectContext.save()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
}
