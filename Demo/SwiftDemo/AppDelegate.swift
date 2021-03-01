//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by liguoliang on 2021/3/1.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }
}

