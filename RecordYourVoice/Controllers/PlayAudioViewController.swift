//
//  PlayAudioViewController.swift
//  RecordYourVoice
//
//  Created by Senrysa on 23/04/21.
//

import UIKit
import AVKit
import AVFoundation
import SwiftSiriWaveformView

class PlayAudioViewController: BaseViewController, AVAudioPlayerDelegate {
    
    var audioURL : String?
    var audioPlayer: AVAudioPlayer?
    var audioFile : AudioRecordList?
    
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTimeRemaining: UILabel!
    @IBOutlet weak var siriWaveFormView: SwiftSiriWaveformView!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        printNew(items: self.audioURL ?? "")
        //let path = Bundle.main.path(forResource: "example.mp3", ofType:nil)!
        //let url = URL(fileURLWithPath: self.audioURL!)
        
        self.title = self.audioFile?.file_name
        setBackBarButtonItem()
        self.siriWaveFormView.density = 1.0
        self.siriWaveFormView.amplitude = 0
        self.lblTimeRemaining.text = Common.convertSecondsToMinutesSeconds(seconds: Int(audioFile?.file_length ?? 0))
        
        let url : NSURL = NSURL(fileURLWithPath: Common.getAudioFileFromDocumentDirectory(fileName: audioFile?.file_name ?? ""))
        //let url = Common.getAudioFileFromDocumentDirectory(fileName: audioFile?.file_name ?? "")

        do {
            let data = NSData(contentsOf: url as URL)
            audioPlayer = try AVAudioPlayer(data: data! as Data)
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.prepareToPlay()
            //bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
            printNew(items: "couldn't load file")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelTimer()
        
    }
    
    func cancelTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    @IBAction func onClickPause(_ sender: UIButton) {
        audioPlayer?.pause()
        btnPause.isEnabled = false
        btnStop.isEnabled = true
        btnPlay.isEnabled = true
        cancelTimer()
        self.siriWaveFormView.amplitude = 0
    }
    
    @IBAction func onClickPlay(_ sender: UIButton) {
        
        audioPlayer?.play()
        btnPlay.isEnabled = false
        btnStop.isEnabled = true
        btnPause.isEnabled = true
        
        self.timer = Timer(timeInterval: 0.3,
                          target: self,
                          selector: #selector(updateTimeLeft),
                          userInfo: nil,
                          repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        //timer.tolerance = 0.1
    }
    
    @IBAction func onClickStop(_ sender: UIButton) {
        audioPlayer?.stop()
        btnPlay.isEnabled = true
        btnStop.isEnabled = true
        btnPause.isEnabled = true
        cancelTimer()
        self.lblTimeRemaining.text = Common.convertSecondsToMinutesSeconds(seconds: Int(audioFile?.file_length ?? 0))
        self.siriWaveFormView.amplitude = 0
    }
    
    @objc func updateTimeLeft() {
        // this for show remain time
        //printNew(items: audioPlayer?.currentTime ?? 0)
        let duration = Int((audioPlayer?.duration ?? 0) - (audioPlayer?.currentTime ?? 0))
        let minutes2 = duration/60
        let seconds2 = duration - minutes2 * 60
        self.lblTimeRemaining.text = NSString(format: "%02d:%02d", minutes2,seconds2) as String
        audioPlayer?.updateMeters()
                
        //printNew(items: audioPlayer?.peakPower(forChannel: 0) ?? 0)
        //printNew(items: audioPlayer?.averagePower(forChannel: 0) ?? 0)
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        DispatchQueue.main.async {
            self.siriWaveFormView.amplitude = CGFloat(self.audioPlayer?.peakPower(forChannel: 0) ?? 0)
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnPlay.isEnabled = true
        btnStop.isEnabled = true
        btnPause.isEnabled = true
        cancelTimer()
        self.lblTimeRemaining.text = Common.convertSecondsToMinutesSeconds(seconds: Int(audioFile?.file_length ?? 0))
        self.siriWaveFormView.amplitude = 0
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
