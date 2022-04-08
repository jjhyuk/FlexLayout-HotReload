//
//  AppDelegate.swift
//  FlexLayout_HotReload
//
//  Created by Denver on 2022/04/08.
//

import UIKit
import Inject

@main
class AppDelegate
: UIResponder
, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let root = Inject.ViewControllerHost(RootViewController())
    window?.rootViewController = root
    window?.makeKeyAndVisible()
    
    return true
  }
}

