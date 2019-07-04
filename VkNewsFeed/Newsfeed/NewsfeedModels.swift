//
//  NewsfeedModels.swift
//  VkNewsFeed
//
//  Created by Shamil on 14/05/2019.
//  Copyright (c) 2019 ShamCode. All rights reserved.
//

import UIKit

enum Newsfeed {

    enum Model {
        
        struct Request {
            
            enum RequestType {
                
                case getNewsfeed
                case getUser
                case revealPostIds(postId: Int)
                case getNextBatch
            }
        }
        
        struct Response {
            
            enum ResponseType {
                
                case presentNewsfeed(feed: FeedResponse, revealedPostIds: [Int])
                case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        
        struct ViewModel {
            
            enum ViewModelData {
                
                case displayNewsfeed(feedViewModel: NewsFeedViewModel)
                case displayUser(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
}

struct UserViewModel: TitleViewViewModel {
    
    var photoUrlString: String?
}

struct NewsFeedViewModel {
    
    struct Cell: NewsfeedCellViewModel {
        
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachementViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachementViewModel {
        
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
    let footerTitle: String?
}
