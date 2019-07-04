//
//  WebImageView.swift
//  VkNewsFeed
//
//  Created by Shamil on 27/05/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    
    func set(imageUrl: String?) {
        currentUrlString = imageUrl
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self.image = UIImage(data: data)
                    self.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        if responseUrl.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }
}
