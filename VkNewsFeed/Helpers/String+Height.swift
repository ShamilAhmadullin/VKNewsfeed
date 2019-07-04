//
//  String+Height.swift
//  VkNewsFeed
//
//  Created by Shamil on 30/05/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(size.height)
    }
}
