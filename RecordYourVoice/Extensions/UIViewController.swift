//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension BaseViewController {
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setBackBarButtonItem() {
        let backButton: UIBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "arrow_back")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.popViewController))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func popViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    func setRightBarButtonItem(title: String) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func rightBarButtonTapped() {
        
    }
    
    
    
    
    
    func removeLeftNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func removeRightNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = nil
    }

    func getDynamicHeight(height:Int)-> CGFloat{
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let heightInt = Int((screenWidth*CGFloat(height))/1032.0)
        let heightFloat = CGFloat(heightInt)
        return heightFloat
    }
    
    func getDynamicWidth(width:Int)-> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let heightInt = Int((screenWidth*CGFloat(width))/1032.0)
        let heightFloat = CGFloat(heightInt)
        return heightFloat
    }
    
}
 
 
extension UIViewController{
    
    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
            else {
                return false
            }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    static func create<T: UIViewController>() -> T {
        let name = String(describing: T.self)

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: T.self))
        if let viewController = storyboard.instantiateViewController(withIdentifier: name) as? T {
            return viewController
        } else {
            fatalError("Cannot find view controller")
        }
    }
}
