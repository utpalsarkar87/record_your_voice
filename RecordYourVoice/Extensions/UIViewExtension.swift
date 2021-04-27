//
//  UIViewExtension.swift
//  RecordYourVoice
//
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(cell:AnyClass,identifier:String? = nil){
        let name  = NSStringFromClass(cell).components(separatedBy: ".").last!
        let nib = UINib.init(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T:UITableViewCell>(cell:AnyClass,for indexPath: IndexPath,identifier:String? = nil) -> T {
        let name  = identifier ?? NSStringFromClass(cell).components(separatedBy: ".").last!
        return self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! T
    }
    func dequeueReusableCell<T:UITableViewCell>(for indexPath: IndexPath,identifier:String? = nil) -> T {
        let name  = identifier ?? NSStringFromClass(T.classForCoder()).components(separatedBy: ".").last!
        return self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! T
    }
}
