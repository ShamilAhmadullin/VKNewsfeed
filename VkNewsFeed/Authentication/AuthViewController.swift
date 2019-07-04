//
//  AuthViewController.swift
//  VkNewsFeed
//
//  Created by Shamil on 11/05/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Property
    
    private var authServise: AuthService!
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        authServise = AppDelegate.shared().authService
    }
    
    // MARK: - IBAction

    @IBAction private func signInTouch() {
        authServise.wakeUpSession()
    }
}
