//
//  YourVoiceListViewModel.swift
//  RecordYourVoice
//
//

import Foundation

class YourVoiceListViewModel {

    var audioPlayList : [AudioRecordList] = []
    let MAX_RECORD_DURATION : TimeInterval = 3599
    var selectedIndex : Int? = -1

    func getIQAudioRecorderViewController() -> IQAudioRecorderViewController {
        let recordController = IQAudioRecorderViewController()
        recordController.maximumRecordDuration = MAX_RECORD_DURATION
        recordController.allowCropping = false
        recordController.barStyle = .default
        return recordController
    }

    func getAudioRecordList(fileName: String?,
                            filePath: String?,
                            recentlyDeleted: Bool?,
                            dateTime: Date?,
                            fileLength: Int64?,
                            dateCreated: String?) -> AudioRecordsList {
        
        return AudioRecordsList(fileName: fileName,
                                filePath: filePath,
                                recentlyDeleted: recentlyDeleted,
                                dateTime: dateTime,
                                fileLength: fileLength,
                                dateCreated: dateCreated)
    }
}
