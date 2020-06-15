//
//  ZPNavigationBarKeys.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 25/01/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public struct NavigationBarPlacementsKeys {
    public static let generalKey  = "state"
    public struct PlacementStates {
        public static let onTop   = "on_top"
        public static let overlay = "overlay"
        public static let hidden  = "hidden"
    }
}

public struct NavigationPresentationKeys {
    public static let generalKey  = "presentation_style"
    public struct PlacementStates {
        public static let logo               = "logo"
        public static let title              = "title"
        public static let logoAndTitleHidden = "hidden"
    }
}

public struct NavigationBackgroundTypeKeys {
    public static let generalKey  = "background_type"
    public struct Types {
        public static let color              = "Color"
        public static let image              = "Image"
    }
}

public struct NavigationBarStyleKeys {
    public static let xibName                      = "style"
    public static let titleLabelColor              = "title_color"
    public static let titleLabelColorTablet        = "title_color_tablet"
    public static let titleLabelFontName           = "ios_font_family"
    public static let titleLabelFontSize           = "title_size"
    public static let titleLabelFontSizeTablet     = "title_size_tablet"
    public static let backgroundColor              = "background_color"
    public static let forceHomeScreenShowLogo      = "homescreen_show_logo"
    public static let backgroundType               = "background_type"
}

public struct NavigationBarAssetsKeys {
    public static let backgroundImage              = "background_image"
    public static let appLogoImage                 = "app_logo"
    public static let backButtonImage              = "back_button"
    public static let closeButtonImage             = "close_button"
    public static let menuButtonImage              = "menu_button"


}
