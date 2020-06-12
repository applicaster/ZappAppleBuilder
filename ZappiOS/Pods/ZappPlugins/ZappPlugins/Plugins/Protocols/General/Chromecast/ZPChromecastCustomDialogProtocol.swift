//
//  ZPChromecastCustomDialogProtocol.swift
//  
//
//  Created by Avi Levin on 21/03/2019.
//

import Foundation

public protocol ZPChromecastCustomDialog: ZPGeneralPluginProtocol {
    func showDialog()
    func dismissDialog()
    func getPlayerNavigation() -> UIViewController
    func getMiniPlayerNavigation() -> UIViewController
}
