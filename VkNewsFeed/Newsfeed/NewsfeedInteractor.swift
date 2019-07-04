//
//  NewsfeedInteractor.swift
//  VkNewsFeed
//
//  Created by Shamil on 14/05/2019.
//  Copyright (c) 2019 ShamCode. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        switch request {
        case .getNewsfeed:
            service?.getFeed() { [weak self] revealPostIds, feed in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealedPostIds: revealPostIds))
            }
        case .getUser:
            service?.getUser() { [weak self] user in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentUserInfo(user: user))
            }
        case .revealPostIds(let postId):
            service?.revealPostIds(forPostId: postId) { [weak self] revealPostIds, feed in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealedPostIds: revealPostIds))
            }
        case .getNextBatch:
            presenter?.presentData(response: .presentFooterLoader)
            service?.getNewBatch() { [weak self] revealPostIds, feed in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealedPostIds: revealPostIds))
            }
        }
    }
}
