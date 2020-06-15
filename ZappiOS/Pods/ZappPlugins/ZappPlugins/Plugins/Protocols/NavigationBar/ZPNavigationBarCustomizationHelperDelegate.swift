//
//  ZPNavigationBarCustomizationHelperDelegate.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 16/01/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol ZPNavigationBarCustomizationHelperDelegate {
    func backgroundColor()    -> UIColor
    func backgroundImageURL() -> URL?
    func fontForTitleLabel()  -> UIFont?
    func colorFotTitleLabel() -> UIColor
    func placementType()      -> ZPNavBarPlacement
    func presentationType()   -> ZPNavBarPresentationStyle
    func navigationBarXib()   -> String?
    func backButtonImage()    -> UIImage?
    func specialButtonImage() -> UIImage?
    func closeButtonImage()   -> UIImage?
    func logoImage()          -> UIImage?
    
    //Addition funtions for automation needs
    @objc optional func identifierForButton(for type:ZPNavBarButtonTypes) -> String
    
    //Temporary items should be removed, when serverside will provide customization perscreen
    @objc optional func forceHomeScreenShowLogo() -> Bool
    @objc optional func backgroundType()     -> ZPNavBarBackgroundType
    
    func backButtonImageURL() -> URL?
    func specialButtonImageURL() -> URL?
    func closeButtonImageURL() -> URL?
    func logoImageURL() -> URL?

    func homeButtonImage()    -> UIImage?
    var customizationModel: NSObject? { get set }
}
