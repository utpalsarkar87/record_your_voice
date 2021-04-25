//
//  Common.swift
//  RecordYourVoice
//
//  Created by Senrysa on 24/04/21.
//

import Foundation

class Common {
    
    static func convertSecondsToMinutesSeconds (seconds : Int) -> String {
        var minute = "\(((seconds % 3600) / 60))"
        if ((seconds % 3600) / 60)<10 {
            minute = "0\(((seconds % 3600) / 60))"
        }
        var second = "\((seconds % 3600) % 60)"
        if ((seconds % 3600) % 60)<10 {
            second = "0\((seconds % 3600) % 60)"
        }
        let audioLength = "\(minute):\(second)"
        return audioLength
    }
    
    static func getAudioFileLength(filePath: String) -> Int64 {
        
        let seamphore = DispatchSemaphore(value: 0)
        var durationInSeconds = 0.0
        let asset = AVURLAsset(url: NSURL(fileURLWithPath: filePath) as URL, options: nil)

        asset.loadValuesAsynchronously(forKeys: ["duration"]) {

            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "duration", error: &error)
            switch status {
            case .loaded: // Sucessfully loaded. Continue processing.
                let duration = asset.duration
                 durationInSeconds = CMTimeGetSeconds(duration)
                print(Int(durationInSeconds))
                break
            case .failed: break // Handle error
            case .cancelled: break // Terminate processing
            default: break // Handle all other cases
            }
            seamphore.signal()
        }
        let _ = seamphore.wait(timeout: .distantFuture)
        return Int64(durationInSeconds)
    }
    
    static func getDateCreated() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        printNew(items: dateString)
        return dateString
    }
    
    static func SaveAudioFile(_ audioFile: String,_ fileName: String, completion: @escaping (String) -> Void) {
            
            //Create directory if not present
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectory = paths.first! as NSString
            let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
            
            do {
                try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
                printNew(items:"directory created at \(soundDirPathString)")
            } catch let error as NSError {
                printNew(items:"error while creating dir : \(error.localizedDescription)");
            }
            
            if let audioUrl = URL(string: audioFile) {     //http://freetone.org/ring/stan/iPhone_5-Alarm.mp3
                // create your document folder url
                let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
                let documentsFolderUrl = documentsUrl.appendingPathComponent("Sounds")
                // your destination file url
                let actualFileName = "\(fileName.replacingOccurrences(of: " ", with: "_")).m4a"
                let destinationUrl = documentsFolderUrl.appendingPathComponent(actualFileName)
                
                // check if it exists before downloading it
                if FileManager().fileExists(atPath: destinationUrl.path) {
                    printNew(items:"The file already exists at path")
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                        do {
                            try FileManager.default.removeItem(atPath: "\(destinationUrl)")
                            printNew(items:"file deleted")
                        }
                        catch {
                            printNew(items:"Failed to delete existing file:\n\((error as NSError).description)")
                        }
                        //if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                        if let myAudioDataFromUrl = FileManager.default.contents(atPath: audioFile) {
                            // after downloading your data you need to save it to your destination url
                            if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                                printNew(items:"file saved")
                                completion(destinationUrl.absoluteString)
                            } else {
                                printNew(items:"error saving file")
                                completion("")
                            }
                        }
                    })
                } else {
                    //  if the file doesn't exist
                    //  just download the data from your url
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                        //let audioData = NSData(contentsOf: audioUrl as URL)
                        //if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                        if let myAudioDataFromUrl = FileManager.default.contents(atPath: audioFile) {
                            // after downloading your data you need to save it to your destination url
                            if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                                printNew(items:"file saved")
                                completion(destinationUrl.absoluteString)
                            } else {
                                printNew(items:"error saving file")
                                completion("")
                            }
                        }
                    })
                }
            }
        }
    
    static func getAudioFileFromDocumentDirectory(fileName: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
        let actualFileName = fileName.replacingOccurrences(of: " ", with: "_")
        let audiofilePath = soundDirPathString.appending("/\(actualFileName).m4a")
        return audiofilePath
    }
}


