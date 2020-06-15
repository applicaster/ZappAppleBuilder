//
//  ZAAppConnector.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 23/06/2018.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public class ZAAppConnector:NSObject {
    static let _sharedInstance = ZAAppConnector()

    @objc open class func sharedInstance() -> ZAAppConnector {
        return _sharedInstance
    }

    @objc public var analyticsDelegate: ZAAppDelegateConnectorAnalyticsProtocol!
    @objc public var genericDelegate:ZAAppDelegateConnectorGenericProtocol!

    public static let enterpriseAppPrefix = "com.applicaster.ent."

#if os(iOS)
    @objc public var localizationDelegate: ZAAppDelegateConnectorLocalizationProtocol!
    @objc public var navigationDelegate: ZAAppDelegateConnectorNavigationProtocol!
    @objc public var layoutsStylesDelegate: ZAAppDelegateConnectorLayoutsStylesProtocol!
    @objc public var timeDelegate: ZAAppDelegateConnectorTimeProtocol!
    @objc public var animationDelegate: ZAAppDelegateConnectorAnimationProtocol!
    @objc public var urlDelegate: ZAAppDelegateConnectorURLProtocol!
    @objc public var firebaseRemoteConfigurationDelegate: ZAAppDelegateConnectorFirebaseRemoteConfigurationProtocol!
    @objc public var chromecastDelegate: ZAAppDelegateConnectorChromecastProtocol!
    @objc public var facebookAccountKitDelegate: ZAAppDelegateConnectorFacebookAccountKitProtocol!
    @objc public var quickBrickDelegate: ZAAppDelegateConnectorQuickBrickProtocol!
    @objc public var componentsDelegate: ZAAppDelegateConnectorComponentsProtocol!
    @objc public var rootDelegate: ZAAppDelegateConnectorRootProtocol!
    @objc public var connectivityDelegate: ZAAppDelegateConnectorConnectivityProtocol!
    @objc public var identityDelegate: ZAAppDelegateConnectorIdentityProtocol!
    @objc public var storeFrontDelegate: ZAAppDelegateConnectorStoreFrontProtocol!
    @objc public var imageDelegate: ZAAppDelegateConnectorImageProtocol!
    public var layoutComponentsDelegate: ZAAppDelegateConnectorLayoutComponentsProtocol!
    public var audioSessionDelegate: ZAAppDelegateConnectorAudioSessionProtocol?
    @objc public var stickyViewDelegate: ZAAppDelegateConnectorStickyViewProtocol!
    @objc public var hqmeDelegate: ZAAppDelegateConnectorHqmeProtocol?
    @objc public var networkDelegate: ZAAppDelegateConnectorNetworkProtocol?
    @objc public var storageDelegate: ZAAppDelegateConnectorStorageProtocol?
    @objc public var pluginsDelegate: ZAAppDelegateConnectorPluginsProtocol?
#endif
    
    public func initializeWithDelegate(delegate:Any) {
        
        if let delegate = delegate as? ZAAppDelegateConnectorAnalyticsProtocol {
            analyticsDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorGenericProtocol {
            genericDelegate = delegate
        }
        
#if os(iOS)

        if let delegate = delegate as? ZAAppDelegateConnectorLocalizationProtocol {
            localizationDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorNavigationProtocol {
            navigationDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorLayoutsStylesProtocol {
            layoutsStylesDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorTimeProtocol {
            timeDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorAnimationProtocol {
            animationDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorURLProtocol {
            urlDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorFirebaseRemoteConfigurationProtocol {
            firebaseRemoteConfigurationDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorChromecastProtocol {
            chromecastDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorFacebookAccountKitProtocol {
            facebookAccountKitDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorQuickBrickProtocol {
            quickBrickDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorComponentsProtocol {
            componentsDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorLayoutComponentsProtocol {
            layoutComponentsDelegate = delegate
        }
        
        if let delegate = delegate as? ZAAppDelegateConnectorRootProtocol {
            rootDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorConnectivityProtocol {
            connectivityDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorIdentityProtocol {
            identityDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorFacebookAccountKitProtocol {
            facebookAccountKitDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorStoreFrontProtocol {
            storeFrontDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorImageProtocol {
            imageDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorAudioSessionProtocol {
            audioSessionDelegate = delegate
        }
        
        if let delegate = delegate as? ZAAppDelegateConnectorStickyViewProtocol {
            stickyViewDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorHqmeProtocol {
            hqmeDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorNetworkProtocol {
            networkDelegate = delegate
        }

        if let delegate = delegate as? ZAAppDelegateConnectorStorageProtocol {
            storageDelegate = delegate
        }
        
        if let delegate = delegate as? ZAAppDelegateConnectorPluginsProtocol {
            pluginsDelegate = delegate
        }
#endif
    }
}
