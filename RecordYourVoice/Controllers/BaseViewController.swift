//
//  BaseViewController.swift
//  RecordYourVoice
//
//

import UIKit

func printNew(items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
}

