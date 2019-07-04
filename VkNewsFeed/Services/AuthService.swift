//
//  AuthService.swift
//  VkNewsFeed
//
//  Created by Shamil on 11/05/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate: class {
    
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignFail()
}

final class AuthService: NSObject {
    
    private let appId = "7038650"
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall", "friends"]
        VKSdk.wakeUpSession(scope) { [weak self] state, error in
            guard let self = self else { return }
            if state == VKAuthorizationState.authorized {
                self.delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                VKSdk.authorize(scope)
            } else {
                print("auth problems, state \(state), error \(String(describing: error))")
                self.delegate?.authServiceDidSignFail()
            }
        }
    }
}

// MARK: - VKSdkDelegate

extension AuthService: VKSdkDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
}

// MARK: - VKSdkUIDelegate

extension AuthService: VKSdkUIDelegate {
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
