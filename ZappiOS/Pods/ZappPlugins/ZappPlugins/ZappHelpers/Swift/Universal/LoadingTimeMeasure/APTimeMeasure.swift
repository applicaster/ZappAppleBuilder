//
//  APLoadingTimeMeasure.swift
//  TestLoad
//
//  Created by Anton Kononenko on 09/07/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import os

@objc public class APTimeMeasure: NSObject {
    private static let sharedInstance = APTimeMeasure()
    private(set) var appDidFinishLoadDate: Date?
    private(set) var postLoadFinishedLoadingDate: Date?

    public class func startMeasurePoint() {
        let sharedInstance = APTimeMeasure.sharedInstance
        sharedInstance.appDidFinishLoadDate = Date()
    }

    @objc public class func retrieveMeasurePoint() {
        let sharedInstance = APTimeMeasure.sharedInstance
        sharedInstance.postLoadFinishedLoadingDate = Date()
        exectutionTime()
    }

    class func exectutionTime() {
        let sharedInstance = APTimeMeasure.sharedInstance

        if let appDidFinishLoadDate = sharedInstance.appDidFinishLoadDate,
            let postLoadFinishedLoadingDate = sharedInstance.postLoadFinishedLoadingDate {
            let executionTime = postLoadFinishedLoadingDate.timeIntervalSince(appDidFinishLoadDate)
            #if os(iOS)
                print("Exectution Time: \(executionTime)")
            #elseif os(tvOS)
                if #available(tvOS 10.0, *) {
                    os_log("Exectution Time: %f", executionTime)
                } else {
                    print("Exectution Time: \(executionTime)")
                }
            #endif
        }
    }
}
