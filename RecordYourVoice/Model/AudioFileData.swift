//
//  AudioFileData.swift
//  RecordYourVoice
//
//  Created by Senrysa on 23/04/21.
//

import Foundation

struct AudioFileData : Codable {
    
    enum AudioFileAttributes : String {
        case
        file_name = "file_name",
        file_path = "file_path",
        date_time = "date_time",
        date_created = "date_created",
        file_length = "file_length",
        recently_deleted = "recently_deleted"
    }
}
