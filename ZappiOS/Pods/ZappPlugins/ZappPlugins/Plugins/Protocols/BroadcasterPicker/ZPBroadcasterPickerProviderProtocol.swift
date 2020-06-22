//
//  ZPBroadcasterPickerProviderProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 08/11/2016.
//  Copyright © 2016 Applicaster Ltd. All rights reserved.
//

import Foundation

/**
 Protocol for broadcaster selection plugin. If you create new implementation - you will must likely want to subclass APBroadcasterPickerBase, which already knows to handle caching. 
 Then if you do so - you only need to implement the select method for your selector and that's it.
 */
@objc public protocol ZPBroadcasterPickerProviderProtocol: ZPAdapterProtocol {
    
    /**
     This method gives you opportunity to return a previous cached broadcaster. If the returned broadcaster is not nil of first launch of the app - the app will not
     Invoke the 'selectBroadcaster' method and will continue launching the app with this broadcaster.
     */
    func getCachedBroadcaster() -> ZPBroadcasterProtocol?
    
    /**
     Implement this method in order to select and return the broadcaster that should be default when app launches for the first time.
     
     broadcaster the selected broadcaster.
     shouldProceedWithAppLauch   In must cases your implementation will invoke this method with true.
                                        It should be false only in case your broadcaster selection should stop the rest of the app loading process.
                                        For example, the localization broadcaster selector in some cases reloads the app and therefore calls this method with
                                        false value before doing so. In case you reload the app - make sure to call this method BEFORE - because this method is the
                                        one changing the actual broadcaster saved in AppData.
     */
    func selectBroadcaster(_ completion: @escaping ((_ broadcaster: ZPBroadcasterProtocol?, _ shouldProceedWithAppLaunch: Bool, _ pickerType:ZPBroadcasterPickerType) -> Void))
    
    /**
     In this method you should handle caching the given broadcaster for later use - when the app is launches the next times.
     */
    func setCachedBroadcaster(_ broadcaster: ZPBroadcasterProtocol?)
    
    /**
     get the type of the current picker
     */
    func broadcasterPickerType() -> ZPBroadcasterPickerType
    
    /**
     Optional function that allows specifying if the application should present the broadcaster picker on launch time.
     */
    @objc optional func shouldDisplayAtApplicationLaunch() -> Bool
}
