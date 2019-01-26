//
//  AppDelegate.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import XCTest
import CoreData
@testable import MokaPos

class CoreDataTestStack {
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContextSpy
    let mainContext: NSManagedObjectContextSpy
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MokaPos")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContextSpy(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        backgroundContext = NSManagedObjectContextSpy(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}


class NSManagedObjectContextSpy: NSManagedObjectContext {
    var expectation: XCTestExpectation?
    var saveWasCalled = false
    
    override func performAndWait(_ block: () -> Void) {
        super.performAndWait(block)
        expectation?.fulfill()
    }
    
    
    override func save() throws {
        try super.save()
        saveWasCalled = true
    }
}
