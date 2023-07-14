//
//  AppearanceManager.swift
//  Framily
//
//  Created by Varun kumar on 14/07/23.
//

import UIKit

/*extension UIViewController {
    static let swizzleViewDidLoad: Void = {
        let originalSelector = #selector(viewDidLoad)
        let swizzledSelector = #selector(swizzledViewDidLoad)
        guard
            let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc private func swizzledViewDidLoad() {
        
        swizzledViewDidLoad()
        
        if let backgroundColor = UIColor(named: "BackGroundColor") {
            UIView.animate(withDuration: 30) {
                self.view.backgroundColor = backgroundColor
            }
        }
    }
}*/

extension UIViewController {
    static let swizzleViewDidLoad: Void = {
        let originalSelector = #selector(viewDidLoad)
        let swizzledSelector = #selector(swizzledViewDidLoad)
        guard
            let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc private func swizzledViewDidLoad() {
       
        swizzledViewDidLoad()
        
        if let backgroundColor = UIColor(named: "BackGroundColour") {
            view.backgroundColor = backgroundColor
        }
    }
}

class BackgroundManager {
    static let shared = BackgroundManager()
    
    var backgroundColor: UIColor {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("BackgroundColorDidChange"), object: nil)
        }
    }
    
    private init() {
       
        if let color = UIColor(named: "BackGroundColor") {
            backgroundColor = color
        } else {
            backgroundColor = .white
        }
    }
}

