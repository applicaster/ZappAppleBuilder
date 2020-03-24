//
//  AppDelegate.swift
//  ZappApple
//
//  Created by Anton Kononenko on 11/13/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import QuickBrickApple
import React
import UIKit
import ZappCore

@UIApplicationMain
class AppDelegate: AppDelegateBase {
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let retVal = super.application(application,
                                       didFinishLaunchingWithOptions: launchOptions)

        UNUserNotificationCenter.current().delegate = self

        return retVal
    }
}
