//
//  AudioRecordList.swift
//  RecordYourVoice
//
//  Created by Senrysa on 23/04/21.
//

import Foundation

struct AudioRecordsList : Encodable {
    var fileName : String?
    var filePath : String?
    var recentlyDeleted : Bool?
    var dateTime : Date?
    var fileLength : Int64?
    var dateCreated : String?
}
