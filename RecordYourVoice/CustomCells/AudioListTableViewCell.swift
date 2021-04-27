//
//  AudioListTableViewCell.swift
//  RecordYourVoice
//
//

import UIKit

class AudioListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblAudioLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(audio: AudioRecordList) {
        lblFileName.text = audio.file_name
        lblDateTime.text = audio.date_created
        lblAudioLength.text = Common
            .convertSecondsToMinutesSeconds(seconds: Int(audio.file_length))
    }

}
