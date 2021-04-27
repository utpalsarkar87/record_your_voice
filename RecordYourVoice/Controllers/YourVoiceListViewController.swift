//
//  YourVoiceListViewController.swift
//  RecordYourVoice
//
//

import UIKit

class YourVoiceListViewController: BaseViewController, IQAudioRecorderViewControllerDelegate, IQAudioCropperViewControllerDelegate {

    @IBOutlet weak var tableViewVoiceList: UITableView!
    @IBOutlet weak var btnCreateNew: UIButton!

    var voiceListViewModel = YourVoiceListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = HomeTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.voiceListViewModel.audioPlayList = RYVCoreDataController.sharedInstance.getAudioPlayList()
        
        DispatchQueue.main.async {
            self.tableViewVoiceList.reloadData()
        }
    }

    @IBAction func onClickCreateNewAudio(_ sender: UIButton) {
        
        let recordController = self.voiceListViewModel.getIQAudioRecorderViewController()
        recordController.delegate = self
        self.presentBlurredAudioRecorderViewControllerAnimated(recordController)
    }
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController,
                                 didFinishWithAudioAtPath filePath: String) {

        let audioData = self.voiceListViewModel
            .getAudioRecordList(fileName: "RYV_\(Common.getDateCreated())",
                                filePath: filePath,
                                recentlyDeleted: false,
                                dateTime: Date(),
                                fileLength: Common.getAudioFileLength(filePath: filePath),
                                dateCreated: Common.getDateCreated())

        RYVCoreDataController.sharedInstance.saveAudioFileData(fileData: audioData)
        
        Common.SaveAudioFile(filePath,audioData.fileName ?? "") { (newPath) in
            DispatchQueue.main.async {
                controller.dismiss(animated: true) {
                    self.voiceListViewModel.audioPlayList = RYVCoreDataController.sharedInstance.getAudioPlayList()
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
    
    func audioCropperController(_ controller: IQAudioCropperViewController,
                                didFinishWithAudioAtPath filePath: String) {

        let audioData = self.voiceListViewModel
            .getAudioRecordList(fileName: "RYV_\(Common.getDateCreated())",
                                filePath: filePath,
                                recentlyDeleted: false,
                                dateTime: Date(),
                                fileLength: Common.getAudioFileLength(filePath: filePath),
                                dateCreated: Common.getDateCreated())
        
        RYVCoreDataController.sharedInstance.saveAudioFileData(fileData: audioData)
        
        Common.SaveAudioFile(filePath,audioData.fileName ?? "") { (newPath) in
            DispatchQueue.main.async {
                controller.dismiss(animated: true) {
                    self.voiceListViewModel.audioPlayList = RYVCoreDataController.sharedInstance.getAudioPlayList()
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
        return self.voiceListViewModel.audioPlayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: AudioListTableViewCell.self, for: indexPath, identifier: Constant.cellIdentifiers.audioListTableViewCell) as! AudioListTableViewCell
        cell.configure(audio: self.voiceListViewModel.audioPlayList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlayAudioViewController.create() as! PlayAudioViewController
        let playListObj = self.voiceListViewModel.audioPlayList[indexPath.row]
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
            let playListObj = self.voiceListViewModel.audioPlayList[indexPath.row]

            let audioData = self.voiceListViewModel
                .getAudioRecordList(fileName: playListObj.file_name,
                                    filePath: playListObj.file_path,
                                    recentlyDeleted: true,
                                    dateTime: playListObj.date_time,
                                    fileLength: playListObj.file_length,
                                    dateCreated: playListObj.date_created)

            RYVCoreDataController.sharedInstance.saveAudioFileData(fileData: audioData)
            self.voiceListViewModel.audioPlayList = RYVCoreDataController.sharedInstance.getAudioPlayList()
            DispatchQueue.main.async {
                self.tableViewVoiceList.reloadData()
            }
        }

        func editData(at indexPath: IndexPath) {
            self.voiceListViewModel.selectedIndex = indexPath.row
            let playListObj = self.voiceListViewModel.audioPlayList[indexPath.row]
            let cropController = self.voiceListViewModel.getIQAudioCropperViewController(playListObj: playListObj)
            cropController.delegate = self
            self.presentBlurredAudioCropperViewControllerAnimated(cropController)
            DispatchQueue.main.async {
                
            }
        }
}
