//
//  Fonts.swift
//  RecipiesQuarterProject
//
//  Created by Kirill Fokov on 03.11.2021.
//

import Foundation
import UIKit

// MARK: - Custom Font Variants
extension UIFont {
    
    class func modern(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "AovelSansRounded", size: size)
    }
    
    class func classic(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "BeckyTahlia", size: size)
    }
}
