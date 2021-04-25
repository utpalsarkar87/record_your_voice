//
//  YourVoiceListViewController.swift
//  RecordYourVoice
//
//  Created by Senrysa on 22/04/21.
//

import UIKit
import IQAudioRecorderController
import IQAudioRecorderController

class YourVoiceListViewController: BaseViewController, IQAudioRecorderViewControllerDelegate, IQAudioCropperViewControllerDelegate {

    @IBOutlet weak var tableViewVoiceList: UITableView!
    @IBOutlet weak var btnCreateNew: UIButton!
    
    var audioPlayList : [AudioRecordList] = []
    let MAX_RECORD_DURATION : TimeInterval = 3599
    var selectedIndex : Int? = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = HomeTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.audioPlayList = RYVCoreDataController.sharedInstance.getAudioPlayList()
        
        DispatchQueue.main.async {
            self.tableViewVoiceList.reloadData()
        }
    }

    @IBAction func onClickCreateNewAudio(_ sender: UIButton) {
        
        let recordController = IQAudioRecorderViewController()
        recordController.delegate = self
        recordController.maximumRecordDuration = MAX_RECORD_DURATION
        recordController.allowCropping = false;
        recordController.barStyle = .default;
        self.presentBlurredAudioRecorderViewControllerAnimated(recordController)
    }
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        
        var audioData = AudioRecordsList()
        audioData.fileName = "RYV_\(Common.getDateCreated())"
        audioData.filePath = filePath
        audioData.recentlyDeleted = false
        audioData.fileLength = Common.getAudioFileLength(filePath: filePath)
        audioData.dateCreated = Common.getDateCreated()
        audioData.dateTime = Date()
        
        RYVCoreDataController.sharedInstance.saveAudioFileData(fileData: audioData)
        
        Common.SaveAudioFile(filePath,audioData.fileName ?? "") { (newPath) in
            DispatchQueue.main.async {
                controller.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        self.tableViewVoiceList.reloadData()
                    }
                }
            }
        }
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func audioCropperController(_ controller: IQAudioCropperViewController, didFinishWithAudioAtPath filePath: String) {
        var audioData = AudioRecordsList()
        audioData.fileName = "RYV_\(Common.getDateCreated())"
        audioData.filePath = filePath
        audioData.recentlyDeleted = false
        audioData.fileLength = Common.getAudioFileLength(filePath: filePath)
        audioData.dateCreated = Common.getDateCreated()
        audioData.dateTime = Date()
        
        RYVCoreDataController.sharedInstance.saveAudioFileData(fileData: audioData)
        
        Common.SaveAudioFile(filePath,audioData.fileName ?? "") { (newPath) in
            DispatchQueue.main.async {
                controller.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        self.tableViewVoiceList.reloadData()
                    }
                }
            }
        }
    }
    
    func audioCropperControllerDidCancel(_ controller: IQAudioCropperViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension YourVoiceListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.audioPlayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: AudioListTableViewCell.self, for: indexPath, identifier: Constant.cellIdentifiers.audioListTableViewCell) as! AudioListTableViewCell
        let playListObj = self.audioPlayList[indexPath.row]
        cell.lblFileName.text = playListObj.file_name
        cell.lblDateTime.text = playListObj.date_created
        cell.lblAudioLength.text = Common.convertSecondsToMinutesSeconds(seconds: Int(playListObj.file_length))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "PlayAudioViewController") as! PlayAudioViewController
        let playListObj = self.audioPlayList[indexPath.row]
        controller.audioURL = playListObj.file_path
        controller.audioFile = playListObj
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
                self.editData(at: indexPath)
            }
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") {  (contextualAction, view, boolValue) in
                self.popupAlert(title: ApplicationName, message: "Are you sure you want to delete this recording?", actionTitles: ["Yes","No"], actions: [{action1 in
                    self.deleteData(at: indexPath)
                },{action2 in
               }
              ])
                
            }
            editAction.image =  UIImage.init(named: "editIcon")
            deleteAction.image =  UIImage.init(named: "deleteIcon")
            deleteAction.backgroundColor = UIColor.init(red: 253.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction,editAction])

            return swipeActions
        }

        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        func deleteData(at indexPath: IndexPath) {
            print(indexPath.row)
            let playListObj = self.audioPlayList[indexPath.row]
            var audioData = AudioRecordsList()
            audioData.fileName = playListObj.file_name
            audioData.filePath = playListObj.file_path
            audioData.recentlyDeleted = true
            audioData.fileLength = playListObj.file_length
            audioData.dateCreated = playListObj.date_created
            audioData.dateTime = playListObj.date_time
            RYVCoreDataController.sharedInstance.saveAudioFileData(fileData: audioData)
            self.audioPlayList = RYVCoreDataController.sharedInstance.getAudioPlayList()
            DispatchQueue.main.async {
                self.tableViewVoiceList.reloadData()
            }
        }

        func editData(at indexPath: IndexPath) {
            self.selectedIndex = indexPath.row
            let playListObj = self.audioPlayList[indexPath.row]
            let cropController = IQAudioCropperViewController(filePath: Common.getAudioFileFromDocumentDirectory(fileName: playListObj.file_name ?? ""))
            cropController.delegate = self
            cropController.barStyle = .default
            DispatchQueue.main.async {
                self.presentBlurredAudioCropperViewControllerAnimated(cropController)
            }
        }
}
