//
//  PersistenceManager.swift
//  APA
//
//  Created by Senrysa on 22/04/21.
//  Copyright © 2020 Senrysa Technologies (P) Ltd. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager: NSObject {
    fileprivate var appDelegate: AppDelegate
    fileprivate var mainContextInstance: NSManagedObjectContext

    //Utilize Singleton pattern by instanciating PersistenceManager only once.
    class var sharedInstance: PersistenceManager {
        struct Singleton {
            static let instance = PersistenceManager()
        }

        return Singleton.instance
    }

    override init() {
        appDelegate = AppDelegate().sharedInstance()
        mainContextInstance = ContextManager.init().mainManagedObjectContextInstance
        super.init()
    }
    
    /**
        Get a reference to the Main Context Instance
    
        - Returns: Main NSmanagedObjectContext
    */
    func getMainContextInstance() -> NSManagedObjectContext {
        return self.mainContextInstance
    }

    /**
        Save the current work/changes done on the worker contexts (the minion workers).
        
        - Parameter workerContext: NSManagedObjectContext The Minion worker Context that has to be saved.
        - Returns: Void
    */
    func saveWorkerContext(_ workerContext: NSManagedObjectContext) {
        //Persist new Event to datastore (via Managed Object Context Layer).
        do {
            try workerContext.save()
        } catch let saveError as NSError {
            printNew(items: "save minion worker error: \(saveError.localizedDescription)")
        }
    }

    /**
        Save and merge the current work/changes done on the minion workers with Main context.
    
        - Returns: Void
    */
    func mergeWithMainContext() {
        do {
            try self.mainContextInstance.save()
        } catch let saveError as NSError {
            printNew(items: "synWithMainContext error: \(saveError.localizedDescription)")
        }
    }
}
