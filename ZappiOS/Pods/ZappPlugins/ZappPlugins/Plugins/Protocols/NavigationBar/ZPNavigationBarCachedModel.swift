//
//  GANavigationBarCachedModel.swift
//  Zapp-App
//
//  Created by Anton Kononenko on 16/01/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public class ZPNavigationBarCachedModel {
    weak private(set) public var model: ZLNavigationModel?
    weak var navBarManagerDelegate:ZPNavigationBarManagerDelegate?
    
    public var rightButtonsCollection = [NavigationButton]()
    
    public init(model: ZLNavigationModel,
         navBarManagerDelegate:ZPNavigationBarManagerDelegate) {
        self.model = model
        self.navBarManagerDelegate = navBarManagerDelegate
        self.prepareButtons()
    }
    
    func prepareButtons() {
        if let navigationItems = model?.navItems {
            rightButtonsCollection = prepareButtons(from: navigationItems)
        }
    }
    
    func prepareButtons(from navItems:[ZLNavigationItem]) -> [NavigationButton] {
        var retVal:[NavigationButton] = []
        
        navItems.forEach { (navItem) in
            if let navigationButton = navBarManagerDelegate?.navigationButton(for: navItem) as? NavigationButton {
                retVal.append(navigationButton)
            }
        }
        
        return retVal
    }
}
