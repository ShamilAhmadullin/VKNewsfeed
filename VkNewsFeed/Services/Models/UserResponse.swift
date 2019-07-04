//
//  UserResponse.swift
//  VkNewsFeed
//
//  Created by Shamil on 16/06/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    
    let photo100: String?
}
