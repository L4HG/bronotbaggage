//
//  AppDelegate.swift
//  XcodeGenDemo
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Instance Properties

    var window: UIWindow?

    // MARK: - Instance Methods

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        window.rootViewController = UINavigationController(rootViewController: BorcheckerViewController())
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
