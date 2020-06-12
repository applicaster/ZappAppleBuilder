//
//  InfoPlistHelper.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 25/08/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Foundation

public class InfoPlistHelper: NSObject {
    @objc public class func preferredStatusBarStyle() -> UIStatusBarStyle {
        guard let statusBarStyleString: String = Bundle.main.infoDictionary?["UIStatusBarStyle"] as? String else {
            return .lightContent
        }

        switch statusBarStyleString {
        case "UIStatusBarStyleDefault":
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        default:
            return .lightContent
        }
    }
}
