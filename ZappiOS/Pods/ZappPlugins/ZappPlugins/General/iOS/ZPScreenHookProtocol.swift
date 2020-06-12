//
//  ZPScreenHookProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 11/9/18.
//  Copyright © 2018 Applicaster LTD. All rights reserved.
//

import Foundation

public protocol ZPScreenHookProtocol {
    
    /// Pointer on view controller that been prehooked
    var preHookedViewController:UIViewController? { get set }
}
