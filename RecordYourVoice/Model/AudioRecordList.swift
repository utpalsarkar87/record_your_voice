//
//  AudioRecordList.swift
//  RecordYourVoice
//
//

import Foundation

struct AudioRecordsList : Encodable {
    var fileName: String?
    var filePath: String?
    var recentlyDeleted: Bool?
    var dateTime: Date?
    var fileLength: Int64?
    var dateCreated: String?

    init(fileName: String?,
         filePath: String?,
         recentlyDeleted: Bool?,
         dateTime: Date?,
         fileLength: Int64?,
         dateCreated: String?) {

        self.fileName = fileName
        self.filePath = filePath
        self.recentlyDeleted = recentlyDeleted
        self.dateTime = dateTime
        self.fileLength = fileLength
        self.dateCreated = dateCreated
    }
}
