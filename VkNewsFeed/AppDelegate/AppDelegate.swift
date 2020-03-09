//
//  AppDelegate.swift
//  VkNewsFeed
//
//  Created by Shamil on 09/05/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit
import VKSdkFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var authService = AuthService()
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        authService.delegate = self
        let authViewController: AuthViewController = AuthViewController.loadFromStoryboard()
        window?.rootViewController = authViewController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        return true
    }
}

// MARK: - AurhServiceDelegate

extension AppDelegate: AuthServiceDelegate {
    
    func authServiceShouldShow(_ viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        let feedViewController: NewsfeedViewController = NewsfeedViewController.loadFromStoryboard()
        let navigationViewController = UINavigationController(rootViewController: feedViewController)
        window?.rootViewController = navigationViewController
    }
    
    func authServiceDidSignFail() {
        print(#function)
    }
}
