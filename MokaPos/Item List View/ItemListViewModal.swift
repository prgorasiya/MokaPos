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
        self.processItemsFrom(list: self.fetchItemsFromDatabase())
        self.fetchItemsFromAPI()
    }
    
    
    func fetchItemsFromAPI() {
        self.service.getItemsData { (response) in
            if let data = response {
                if self.saveInCoreDataWith(array: data) {
                    self.processItemsFrom(list: self.fetchItemsFromDatabase())
                }
                else{
                    self.delegate?.finishLoading()
                }
            }
            else{
                self.delegate?.finishLoading()
            }
        }
    }
    
    
    func fetchItemsFromDatabase() -> [Item]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let results = Item.fetchFromManagedObjectContext(moc: managedObjectContext, request: fetchRequest)
        if results != nil {
            return results
        }
        return nil
    }
    
    
    func processItemsFrom(list: [Item]?) {
        if list != nil {
            self.delegate?.finishLoading()
            self.delegate?.setItems(data: list!)
        }
        else{
            self.delegate?.finishLoading()
        }
    }
    
    
    private func saveInCoreDataWith(array: [[String: Any]]) -> Bool {
        if Item.deleteAllFrom(moc: managedObjectContext) {
            _ = array.map{Item.createInManagedObjectContext(moc: managedObjectContext, json: $0)}
            do {
                try managedObjectContext.save()
                return true
            } catch let error {
                print(error)
                return false
            }
        }
        return false
    }
}
