//
//  NavigationButton.swift
//  Zapp-App
//
//  Created by Anton Kononenko on 15/12/2017.
//  Copyright © 2017 Applicaster LTD. All rights reserved.
//

import Foundation

open class NavigationButton: UIButton {

    required public init(model: ZLNavigationItem) {
        super.init(frame: .zero)
        self.model = model
        prepareButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var model: ZLNavigationItem? {
        didSet {
            if oldValue !== model {
                prepareButton()
            }
        }
    }

    public var screenType:String? {
        guard let screenID = model?.data.targetID else {
            return nil
        }
        return screenID
    }
    
    public var dataSourceURLString:String? {
        guard let dataSourceURLString = model?.data.dataSource?.source else {
            return nil
        }
        return dataSourceURLString
    }
    
    public var imageURLString:String? {
        return model?.assets["icon"] as? String
    }
    
    public var imageSelectedURLString:String?  {
        return model?.assets["icon_selected"] as? String
    }
    
    open func prepareButton() {
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .fill
        let placeholderImage = UIImage(named: "navbar_link_icon")
  
        if let imageString = imageURLString {
            prepareButton(imageURLString: imageString,
                          controlState: .normal,
                          placeholderImage:placeholderImage)
        } else {
            setImage(placeholderImage, for: .normal)
        }
        
        if let imageString = imageSelectedURLString {
            prepareButton(imageURLString: imageString,
                          controlState: .selected,
                          placeholderImage:placeholderImage)
            prepareButton(imageURLString: imageString,
                          controlState: .highlighted,
                          placeholderImage:placeholderImage)
        } else {
            setImage(nil, for: .selected)
            setImage(nil, for: .highlighted)
        }
    }

    open func prepareButton(for imageURL:URL?,
                              controlState:UIControl.State = .normal,
                              placeholderImage:UIImage? = nil) {

        guard let imageURL = imageURL else {
            setImage(placeholderImage, for: controlState)
            
            return
        }

        if imageURL.pathExtension == "gif" {
            self.setImage(placeholderImage,
                          for: controlState)

            ZAAppConnector.sharedInstance().imageDelegate.setAnimatedImage(forButton: self,
                                                                             url: imageURL,
                                                                             controlState: controlState)
        } else {
            ZAAppConnector.sharedInstance().imageDelegate.setImage(with: imageURL,
                                                                   placeholderImage: placeholderImage) { (image, error) in
                                                                    if let image = image {
                                                                        self.setImage(image,
                                                                                      for: controlState)
                                                                    }
            }
        }
    }
    
    open func prepareButton(imageURLString:String?,
                              controlState:UIControl.State = .normal,
                              placeholderImage:UIImage? = nil) {

        if let imageURLString = imageURLString,
            imageURLString.isNotEmptyOrWhiteSpaces() == true {
            prepareButton(for: URL(string:imageURLString),
                        controlState: controlState,
                        placeholderImage: placeholderImage)
        } else {
            setImage(placeholderImage, for: controlState)
        }
    }
}

