//
//  NewsfeedPresenter.swift
//  VkNewsFeed
//
//  Created by Shamil on 14/05/2019.
//  Copyright (c) 2019 ShamCode. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    weak var viewController: NewsfeedDisplayLogic?
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    let dateFormatter: DateFormatter = {
        let tempDateFrmatter = DateFormatter()
        tempDateFrmatter.locale = Locale(identifier: "ru_RU")
        tempDateFrmatter.dateFormat = "d MMM 'в' HH:mm"
        return tempDateFrmatter
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsfeed(let feed, let revealPostIds):
            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealPostIds: revealPostIds)
            }
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("NewsfeedСellsСount", comment: ""), cells.count)
            let feedViewModel = NewsFeedViewModel(cells: cells, footerTitle: footerTitle)
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        case .presentUserInfo(let user):
            let userViewModel = UserViewModel(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealPostIds: [Int]) -> NewsFeedViewModel.Cell {
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let isFullSized = revealPostIds.contains { postId in
            return postId == feedItem.postId
        }
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizedPost: isFullSized)
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        return NewsFeedViewModel.Cell(postId: feedItem.postId,
                                      iconUrlString: profile?.photo ?? "",
                                      name: profile?.name ?? "",
                                      date: dateTitle ,
                                      text: postText,
                                      likes: formattedCounter(feedItem.likes?.count),
                                      comments: formattedCounter(feedItem.comments?.count),
                                      shares: formattedCounter(feedItem.reposts?.count),
                                      views: formattedCounter(feedItem.views?.count),
                                      photoAttachments: photoAttachments, sizes: sizes)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3) + "K")
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6) + "M")
        }
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable? {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { myProfileRepresentable -> Bool in
            myProfileRepresentable.id == normalSourceId
        }
        return profileRepresentable
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [NewsFeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap({ attachments in
            guard let photo = attachments.photo else { return nil }
            return NewsFeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.scrBIG, width: photo.width, height: photo.height)
        })
    }
}
