//
//  UIView+APAdditions.swift
//  ZappPlugins
//
//  Created by Guy Kogus on 24/08/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import UIKit

public extension UIView {

	/**
	Helper function to create or override a layout constraint.

	- parameter firstAttribute: The receiver's layout attribute to set.
	- parameter secondView: The second view to constrain against. Defaults to `nil`.
	- parameter secondAttribute: The layout attribute of secondView against which to constrain. Defaults to `.notAnAttribute`.
	- parameter constant: The constant value to set for the constraint.
	- parameter priority: The priority of the constraint. Defaults to `UILayoutPriorityRequired`.

	- returns: A new constraint if it was created, otherwise the constraint that was overridden.
	*/
	@objc @discardableResult func setConstraint(
        for firstAttribute: NSLayoutConstraint.Attribute,
		secondView: AnyObject? = nil,
        secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute,
		to constant: CGFloat,
		priority: UILayoutPriority = .required
		) -> NSLayoutConstraint {

		let constraint: NSLayoutConstraint

		if let existingConstraint = constraints.first(where: {
			$0.firstItem === self &&
				$0.firstAttribute == firstAttribute &&
				$0.secondItem === secondView &&
				$0.secondAttribute == secondAttribute
		}) {
			if existingConstraint.priority == priority {
				existingConstraint.constant = constant
				constraint = existingConstraint
			} else {
				// The priority cannot be changed on an active constraint, so recreate it
				existingConstraint.isActive = false
				constraint = setConstraint(for: firstAttribute,
					secondView: secondView,
					secondAttribute: secondAttribute,
					to: constant,
					priority: priority)
			}
		} else {
			constraint = NSLayoutConstraint(
				item: self,
				attribute: firstAttribute,
				relatedBy: .equal,
				toItem: secondView,
				attribute: secondAttribute,
				multiplier: 1,
				constant: constant
			)
			constraint.priority = priority
			constraint.isActive = true
		}

		return constraint
	}
    
    /**
     Helper function to set the view background color
     
     - parameter key: The background key inside the dictionary to look for.
     - parameter dictionary: styles dictionary.
     */
    @objc func setBackgroundColor(key:String, from dictionary:[String : Any]?) {
        if let dictionary = dictionary,
            let argbString = dictionary[key] as? String,
            !argbString.isEmptyOrWhitespace() {
            let color = UIColor(argbHexString: argbString)
            self.backgroundColor = color
        }
    }
}

public extension UIView {
    
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
    
    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }
    
    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get<T: UIView>(all type: T.Type) -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get(all types: [UIView.Type]) -> [UIView] { return UIView.getAllSubviews(from: self, types: types) }
}
