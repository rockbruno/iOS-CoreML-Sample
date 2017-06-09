//
//  AppDelegate.swift
//  CoreMLSample
//
//  Created by Bruno Rocha on 6/8/17.
//  Copyright © 2017 Bruno Rocha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CameraViewController()
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        UIApplication.shared.isStatusBarHidden = true
        return true
    }
}
