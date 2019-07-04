//
//  NetworkDataFetcher.swift
//  VkNewsFeed
//
//  Created by Shamil on 12/05/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import Foundation

protocol DataFetcher {
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    private let authService: AuthService
    
    init(networking: Networking, authService: AuthService = AppDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var parameters = ["filters": "post, photo"]
        parameters["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, parameters: parameters) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
            }
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let parameters = ["fields": "photo_100", "user_ids": userId]
        networking.request(path: API.user, parameters: parameters) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
            }
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
