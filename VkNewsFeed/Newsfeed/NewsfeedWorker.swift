//
//  NewsfeedWorker.swift
//  VkNewsFeed
//
//  Created by Shamil on 14/05/2019.
//  Copyright (c) 2019 ShamCode. All rights reserved.
//

import UIKit

class NewsfeedService {

    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetcher
    
    private var revealedPostIds: [Int] = []
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String?
    
    init() {
        self.authService = AppDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            completion(userResponse)
        }
    }
    
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] feed in
            guard let self = self else { return }
            self.feedResponse = feed
            guard let feedResponse = self.feedResponse else { return }
            completion(self.revealedPostIds, feedResponse)
        }
    }
    
    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
    }
    
    func getNewBatch(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] feed in
            guard let self = self else { return }
            guard let feed = feed else { return }
            guard self.feedResponse?.nextFrom != feed.nextFrom else { return }
            if self.feedResponse == nil {
                self.feedResponse = feed
            } else {
                self.feedResponse?.items.append(contentsOf: feed.items)
                var profiles = feed.profiles
                if let oldProfiles = self.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter { oldProfile -> Bool in
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    }
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self.feedResponse?.profiles = profiles
                var groups = feed.groups
                if let oldGroupes = self.feedResponse?.groups {
                    let oldGroupesFiltered = oldGroupes.filter { oldGroupe -> Bool in
                        !feed.groups.contains(where: { $0.id == oldGroupe.id })
                    }
                    groups.append(contentsOf: oldGroupesFiltered)
                }
                self.feedResponse?.groups = groups
                self.feedResponse?.nextFrom = feed.nextFrom
            }
            guard let feedResponse = self.feedResponse else { return }
            completion(self.revealedPostIds, feedResponse)
        }
    }
}
