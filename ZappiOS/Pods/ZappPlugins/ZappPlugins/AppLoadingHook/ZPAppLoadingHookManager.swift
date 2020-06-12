 //
 //  ZPAppLoadingHookManager.swift
 //  Pods
 //
 //  Created by Miri on 30/03/2017.
 //
 //
 
 import Foundation
 import ZappCore
 
 @objc public class ZPAppLoadingHookManager: NSObject {
    
    @objc public static let sharedInstance = ZPAppLoadingHookManager()
    
    @objc public func executeOnFailedLoading( completion: ((_: Bool) -> Void)?) {
        let dispatchGroup = DispatchGroup()
        var wasHandled = true
        
        guard let pluginModels = getHookPlugins() else {
            completion?(false)
            return
        }
        
        for pluginModel in pluginModels {
            if  let plugin = self.getPluginByModel(pluginModel: pluginModel),
                let executionMethod = plugin.executeOnFailedLoading {
                
                wasHandled = true
                
                dispatchGroup.enter()
                DispatchQueue.main.async {
                    executionMethod() {
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(wasHandled)
        }
    }
    
    @objc public func executeOnLaunch( completion: (() -> Void)?) {
        if let pluginModels = getHookPlugins() {
            self.executeOnLaunchRecursive(pluginModels: pluginModels, completion: {
                completion?()
            })
        }
        else {
            completion?()
        }
    }

    private func executeOnLaunchRecursive(pluginModels: [ZPPluginModel], completion: (() -> Void)?) {
        if let pluginModel = pluginModels.first {
            let reducedPlugins = self.getReducedPluginModels(pluginModels)
            if let plugin = self.getPluginByModel(pluginModel: pluginModel) as ZPAppLoadingHookProtocol?,
                let executeOnLaunch = plugin.executeOnLaunch {
                executeOnLaunch({ () in
                    self.executeOnLaunchRecursive(pluginModels: reducedPlugins,
                                                  completion: completion)
                })
            }
            else {
                self.executeOnLaunchRecursive(pluginModels: reducedPlugins,
                                              completion: completion)
            }
        }
        else {
            completion?()
        }
    }
    
    @objc public func executeOnApplicationReady(displayViewController: UIViewController?, completion: (() -> Void)?) {
        if let pluginModels = getHookPlugins() {
            self.executeOnApplicationReadyRecursive(pluginModels: pluginModels,displayViewController: displayViewController, completion: {
                completion?()
            })
        }
        else {
            completion?()
        }
    }
    
    private func executeOnApplicationReadyRecursive(pluginModels: [ZPPluginModel], displayViewController: UIViewController?, completion: (() -> Void)?) {
        if let pluginModel = pluginModels.first {
            let reducedPlugins = self.getReducedPluginModels(pluginModels)
            if let plugin = self.getPluginByModel(pluginModel: pluginModel) as ZPAppLoadingHookProtocol?,
                let executeOnApplicationReady = plugin.executeOnApplicationReady {
                executeOnApplicationReady(displayViewController, {() in
                    self.executeOnApplicationReadyRecursive(pluginModels: reducedPlugins,
                                                            displayViewController: displayViewController,
                                                            completion: completion)
                })
            }
            else {
                self.executeOnApplicationReadyRecursive(pluginModels: reducedPlugins,
                                                        displayViewController: displayViewController,
                                                        completion: completion)
            }
        }
        else {
            completion?()
        }
    }
    
    @objc public func executeAfterAppRootPresentation(displayViewController: UIViewController?, completion: (() -> Void)?) {
        if let pluginModels = getHookPlugins() {
            self.executeAfterAppRootPresentationRecursive(pluginModels: pluginModels,displayViewController: displayViewController, completion: {
                completion?()
            })
        }
        else {
            completion?()
        }
    }
    
    private func executeAfterAppRootPresentationRecursive(pluginModels: [ZPPluginModel], displayViewController: UIViewController?, completion: (() -> Void)?) {
        if let pluginModel = pluginModels.first {
            let reducedPlugins = self.getReducedPluginModels(pluginModels)
            if let plugin = self.getPluginByModel(pluginModel: pluginModel) as ZPAppLoadingHookProtocol?,
                let executeAfterAppRootPresentation = plugin.executeAfterAppRootPresentation {
                executeAfterAppRootPresentation(displayViewController, {() in
                    self.executeAfterAppRootPresentationRecursive(pluginModels: reducedPlugins,
                                                                  displayViewController: displayViewController,
                                                                  completion: completion)
                })
            }
            else {
                self.executeAfterAppRootPresentationRecursive(pluginModels: reducedPlugins,
                                                              displayViewController: displayViewController,
                                                              completion: completion)
            }
        }
        else {
            completion?()
        }
    }
    
    @objc public func executeOnContinuingUserActivity(_ userActivity: NSUserActivity?, completion: (() -> Void)?) {
        if let pluginModels = getHookPlugins() {
            self.executeOnContinuingUserActivityRecursive(pluginModels: pluginModels, userActivity: userActivity, completion: {
                completion?()
            })
        }
        else {
            completion?()
        }
    }
    
    private func executeOnContinuingUserActivityRecursive(pluginModels: [ZPPluginModel], userActivity: NSUserActivity?, completion: (() -> Void)?) {
        if let pluginModel = pluginModels.first {
            let reducedPlugins = self.getReducedPluginModels(pluginModels)
            if let plugin = self.getPluginByModel(pluginModel: pluginModel) as ZPAppLoadingHookProtocol?,
                let executeOnContinuingUserActivity = plugin.executeOnContinuingUserActivity {
                executeOnContinuingUserActivity(userActivity, { () in
                    self.executeOnContinuingUserActivityRecursive(pluginModels: reducedPlugins,
                                                                  userActivity: userActivity,
                                                                  completion: completion)
                })
            }
            else {
                self.executeOnContinuingUserActivityRecursive(pluginModels: reducedPlugins,
                                                              userActivity: userActivity,
                                                              completion: completion)
            }
        }
        else {
            completion?()
        }
    }
    
    func getReducedPluginModels(_ pluginModels: [ZPPluginModel]) -> [ZPPluginModel] {
        var pluginModelsReduced = pluginModels
        pluginModelsReduced.removeFirst()
        return pluginModelsReduced
    }
    
    func getPluginByModel(pluginModel: ZPPluginModel) -> (ZPAppLoadingHookProtocol?)  {
        var plugin: ZPAppLoadingHookProtocol?
        if let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPAppLoadingHookProtocol.Type {
            plugin = classType.init(configurationJSON: pluginModel.configurationJSON)
        }
        return plugin
    }
    
    func getHookPlugins() -> [ZPPluginModel]? {
        return ZPPluginManager.pluginModels()?.filter { $0.pluginRequireStartupExecution == true }
    }
 }
