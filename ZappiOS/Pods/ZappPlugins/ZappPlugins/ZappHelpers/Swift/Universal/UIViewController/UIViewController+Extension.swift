//
//  UIViewController+APAdditions.swift
//  ZappPlugins
//
//  Created by Pablo Rueda on 09/04/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import UIKit

@objc public extension UIViewController {
    
    /// Present a modal view controller using an animation from Right to Left (similar to a push navigation)
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to display over the current view controller’s content.
    ///   - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func presentPushAnimated(_ viewControllerToPresent: UIViewController, completion: (() -> Swift.Void)? = nil) {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: completion) //Animated should be false to don't display twice the animation
    }
    
    /// Dismiss a modal view controller using an animation from Left to Right (similar to a push navigation)
    ///
    /// - Parameter completion: The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func dismissPushAnimated(completion: (() -> Swift.Void)? = nil) {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: completion) //Animated should be false to don't display twice the animation
    }

}
