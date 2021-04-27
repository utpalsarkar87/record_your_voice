//
//  RYVCoreDataController.swift
//  APA
//
//

import Foundation
import CoreData

class RYVCoreDataController: NSObject {
    
    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!
    
    
    class  var sharedInstance: RYVCoreDataController {
        struct singleton {
            static let instance=RYVCoreDataController()
        }
        return singleton.instance
    }
    
    override init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }
    
    func saveAudioFileData(fileData: AudioRecordsList) {
        
        var fetchedResults: Array<AudioRecordList> = Array<AudioRecordList>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.AudioRecordList.rawValue)
        fetchRequest.predicate = NSPredicate(format: "file_name = %@", fileData.fileName!)
        fetchRequest.returnsObjectsAsFaults = false
        
        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [AudioRecordList]
            if fetchedResults.count != 0 {
                // update
                let managedObject = fetchedResults[0] as AudioRecordList
                managedObject.setValue(fileData.fileName, forKey: AudioFileData.AudioFileAttributes.file_name.rawValue)
                managedObject.setValue(fileData.filePath, forKey: AudioFileData.AudioFileAttributes.file_path.rawValue)
                managedObject.setValue(fileData.fileLength, forKey: AudioFileData.AudioFileAttributes.file_length.rawValue)
                managedObject.setValue(fileData.dateCreated, forKey: AudioFileData.AudioFileAttributes.date_created.rawValue)
                managedObject.setValue(fileData.dateTime, forKey: AudioFileData.AudioFileAttributes.date_time.rawValue)
                managedObject.setValue(fileData.recentlyDeleted, forKey: AudioFileData.AudioFileAttributes.recently_deleted.rawValue)
            
                try? self.mainContextInstance.save()

        } else {
                //Minion Context worker with Private Concurrency type.
                let minionManagedObjectContextWorker: NSManagedObjectContext =
                    NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                minionManagedObjectContextWorker.parent = self.mainContextInstance
                
                //Create new Object of User entity
                let managedObject = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.AudioRecordList.rawValue, into: minionManagedObjectContextWorker)
                managedObject.setValue(fileData.fileName, forKey: AudioFileData.AudioFileAttributes.file_name.rawValue)
                managedObject.setValue(fileData.filePath, forKey: AudioFileData.AudioFileAttributes.file_path.rawValue)
                managedObject.setValue(fileData.fileLength, forKey: AudioFileData.AudioFileAttributes.file_length.rawValue)
                managedObject.setValue(fileData.dateCreated, forKey: AudioFileData.AudioFileAttributes.date_created.rawValue)
                managedObject.setValue(fileData.dateTime, forKey: AudioFileData.AudioFileAttributes.date_time.rawValue)
                managedObject.setValue(fileData.recentlyDeleted, forKey: AudioFileData.AudioFileAttributes.recently_deleted.rawValue)                
                
                //Save current work on Minion workers
                self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
                
                //Save and merge changes from Minion workers with Main context
                self.persistenceManager.mergeWithMainContext()
            }
        } catch let fetchError as NSError {
                    printNew(items: "retrieveById error: \(fetchError.localizedDescription)")
                    fetchedResults = Array<AudioRecordList>()
            }
    }
    
    func getAudioPlayList() -> Array<AudioRecordList> {
        var fetchedResults: Array<AudioRecordList> = Array<AudioRecordList>()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.AudioRecordList.rawValue)
        fetchRequest.predicate = NSPredicate(format: "recently_deleted = %d", 0)
        fetchRequest.returnsObjectsAsFaults = false
        
        //Execute Fetch request
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [AudioRecordList]
        } catch let fetchError as NSError {
            printNew(items: "retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<AudioRecordList>()
        }
        
        return fetchedResults
    }    
}
