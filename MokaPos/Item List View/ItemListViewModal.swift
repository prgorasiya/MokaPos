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
    
    
    //Fetching all items from core data and also calling method to fetch from API
    func fetchAllItems() {
        self.delegate?.startLoading()
        self.processItemsFrom(list: self.fetchItemsFromDatabase())
        self.fetchItemsFromAPI()
    }
    
    
    //Fetch items from API and store to core data
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
        let results = Item.fetchFor(request: fetchRequest)
        if results != nil {
            return results
        }
        return nil
    }
    
    
    //Setting items array to view
    func processItemsFrom(list: [Item]?) {
        if list != nil {
            self.delegate?.finishLoading()
            self.delegate?.setItems(data: list!)
        }
        else{
            self.delegate?.finishLoading()
        }
    }
    
    
    //Save Item JSON to core data
    private func saveInCoreDataWith(array: [[String: Any]]) -> Bool {
        if Item.deleteAll() {
            _ = array.map{Item.createFrom(json: $0)}
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
