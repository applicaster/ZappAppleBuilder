//
//  ZAAppDelegateConnectorNetworkProtocol.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 20/05/2019.
//

import Foundation

@objc public protocol ZAAppDelegateConnectorNetworkProtocol {

    @objc @discardableResult func requestJsonObject(forRequest request:URLRequest,
                                                    completion: ((Bool, Any?, Error?, Int) -> Void)?) -> URLSessionTask?

    @objc @discardableResult func requestJsonObject(forRequest request:URLRequest,
                                                    queue: DispatchQueue?,
                                                    completion: ((Bool, Any?, Error?, Int) -> Void)?) -> URLSessionTask?

    @objc func requestJsonObject(forUrlString urlString:String,
                                 method: String,
                                 parameters:[String: Any]?,
                                 completion: ((Bool, Any?, Error?, Int) -> Void)?)


    @objc @discardableResult func requestJsonObject(forUrlString urlString:String,
                                                    method: String,
                                                    parameters:[String: Any]?,
                                                    queue: DispatchQueue?,
                                                    completion: ((Bool, Any?, Error?, Int) -> Void)?) -> URLSessionTask?


    @objc @discardableResult func requestJsonObject(forUrlString urlString:String,
                                                    method: String,
                                                    parameters:[String: Any]?,
                                                    queue: DispatchQueue?,
                                                    headers: [String: String]?,
                                                    completion: ((Bool, Any?, Error?, Int) -> Void)?) -> URLSessionTask?


    @objc func requestDataObject(forUrlString urlString:String,
                                 method: String,
                                 parameters:[String: Any]?,
                                 completion: ((Bool, Data?, Error?, Int, String?) -> Void)?)

    @objc @discardableResult func requestDataObject(forRequest request:URLRequest,
                                                                  completion: ((Bool, Data?, Error?, Int) -> Void)?) -> URLSessionTask?
}
