//
//  BaseViewController.swift
//  MarketWatch
//
//  Created by Senrysa on 28/02/21.
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
