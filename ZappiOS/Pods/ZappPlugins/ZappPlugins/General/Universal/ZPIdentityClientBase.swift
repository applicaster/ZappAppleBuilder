//
//  ZPIdentityClientBase.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 1/28/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

/**
 This class is used to manage identity in various places.
 This identity is used agains the applicaster servers as a de-facto replacement of the Apple identifier parameter.

 This identifier is unique identifier supplied by the server and stored in a persistent way in the keychain.
 */
@objc open class ZPIdentityClientBase: NSObject {
    /// Error meassage if URL can not be created
    let errorMessageSessionCanNotCreate = "Session URL can not be created"

    /// API Keys
    public struct ZPIdentityClientBaseKeys {
        /// Template url for session request
        /// Example "https://ais-api.applicaster.com/api/v1/buckets/4f812e2037d0d541bb000003/sessions.json"
        static let sessionURLTemplate = "%@buckets/%@/sessions.json"

        /// Templater url for create device
        static let createDeviceTemplate = "%@buckets/%@/devices.json"

        /// Post request method
        public static let PostMethod = "POST"

        /// Put request method
        public static let PutMethod = "PUT"

        /// Delete request method
        public static let DeleteMethod = "DELETE"

        /// UUID from response of session
        static let sessionResponseUUID = "id"

        /// Token  from response of session
        static let sessionResponseToken = "token"

        /// Device type iPhone key
        static let iPhoneDeviceKey = "iPhone"

        /// Device type iPad key
        static let iPadDeviceKey = "iPad"

        /// Device type tv key
        static let tvDeviceKey = "AppleTv"
    }

    /// Server type struct keys
    public struct ZPIdentityClientBaseServerType {
        public init(serverURL: String,
                    UUIDKey: String,
                    tokenKey: String) {
            self.serverURL = serverURL
            self.UUIDKey = UUIDKey
            self.tokenKey = tokenKey
        }

        /// Server URL Keys
        public let serverURL: String

        /// Server UUID Key
        public let UUIDKey: String

        /// Server Token Key
        public let tokenKey: String
    }

    /// Default params that relevant for all requests
    struct ZPIdentityClientDefaultParams {
        /// OS Version
        static let deviceOSVersion = "device[os_version]"

        /// Bundle Version
        static let deviceBundleVersion = "device[bundle_ver]"

        /// Bundle ID
        static let deviceBundleID = "device[bundle_id]"
    }

    /// Params that relevant for sessions requests
    struct ZPIdentityClientSessionParams {
        /// Device Identifier
        static let deviceID = "device[id]"

        /// Device Token
        static let deviceToken = "device[token]"
    }

    /// Params that relevant for create device requests
    struct ZPIdentityClientDeviceParams {
        /// Device Model
        static let deviceModel = "device[device_model]"

        /// Device Type
        static let deviceType = "device[os_type]"

        /// Default Device Type Value
        static let deviceTypeValue = "ios"
    }

    /// General keys for AIS server
    public static var serverType = ZPIdentityClientBaseServerType(serverURL: "https:/ais.applicaster.com/api/v1/",
                                                                  UUIDKey: "APUUID",
                                                                  tokenKey: "APToken")

    /// The current bucket ID
    @objc public var bucketID: String = ""

    /// The unique identifier for this user.
    /// The unique identifier if one has been generated. <code>nil</code> otherwise.
    @objc public static var deviceID: String? {
        return APKeychain.getStringForKey(serverType.UUIDKey)
    }

    /// The token for this user.
    /// The token if one has been generated or <code>nil</code> if the latest token has expired or if none have been generated.
    @objc public static var token: String? {
        return APKeychain.getStringForKey(serverType.tokenKey)
    }

    /// Convinience initialization with bucket ID
    ///
    /// - Parameter bucketID: String representaion of device bucket ID
    public convenience init(bucketID: String) {
        self.init()
        self.bucketID = bucketID
    }

    /// Try to generate a new session token.
    /// - Parameter completion: Completions with creation session result.
    open func createSession(completion: ((_ success: Bool, _ responseObject: [String: Any]?, _ responseCode: ZPHTTPStatusCode?) -> Void)? = nil) {
        guard let sessionURLRequest = createURLRequest(from: sessionURL) else {
            let error = NSError(domain: errorMessageSessionCanNotCreate,
                                code: -1,
                                userInfo: nil)
            debugPrint(error.localizedDescription)
            completion?(false, nil, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: sessionURLRequest) { [weak self] data, response, _ in
            var statusCode: ZPHTTPStatusCode?
            var responseObject: [String: Any]?

            if let response = response as? HTTPURLResponse {
                statusCode = response.status
                if let responseObjectDict = self?.dictFromData(data: data) {
                    responseObject = responseObjectDict
                }

                if statusCode == .forbidden {
                    // In case session generation failed - check if its because of HTTP error 403.
                    // In that case - post a notification - delete local Identifiers and close the app
                    APKeychain.deleteString(forKey: ZPIdentityClientBase.serverType.UUIDKey)
                    APKeychain.deleteString(forKey: ZPIdentityClientBase.serverType.tokenKey)
                }
            }
            completion?(statusCode == .ok,
                        responseObject,
                        statusCode)
        }

        task.resume()
    }

    /// Create URL Request for specific method type
    ///
    /// - Parameters:
    ///   - url: URL that Request will use
    ///   - method: mehtod type POST/PUT/DELETE
    /// - Returns: URL Request instance if can be created for specific URL
    public func createURLRequest(from url: URL?,
                                 method: String = ZPIdentityClientBaseKeys.PostMethod) -> URLRequest? {
        guard let url = url,
            isRestMethodAvailible(method: method) else {
            return nil
        }
        var retVal = URLRequest(url: url)
        retVal.httpMethod = method
        return retVal
    }

    /// Check if method sting supported
    ///
    /// - Parameter method: REST method in string
    /// - Returns: true if method uspported otherwise false
    func isRestMethodAvailible(method: String) -> Bool {
        return method == ZPIdentityClientBaseKeys.PostMethod ||
            method == ZPIdentityClientBaseKeys.PutMethod ||
            method == ZPIdentityClientBaseKeys.DeleteMethod
    }

    /// URL to generate a new session token.
    var sessionURL: URL? {
        let urlPath = String(format: ZPIdentityClientBaseKeys.sessionURLTemplate,
                             ZPIdentityClientBase.serverType.serverURL,
                             bucketID)
        var urlComponent = URLComponents(string: urlPath)
        urlComponent?.queryItems = sessionURLQueryItems
        return urlComponent?.url
    }

    ///  URL to generate new device unique identifier
    var createDeviceURL: URL? {
        let urlPath = String(format: ZPIdentityClientBaseKeys.createDeviceTemplate,
                             ZPIdentityClientBase.serverType.serverURL,
                             bucketID)
        var urlComponent = URLComponents(string: urlPath)
        urlComponent?.queryItems = deviceURLQueryItems
        return urlComponent?.url
    }

    /// Default params to pass through all avail url request
    var defaultURLQueryItems: [URLQueryItem] {
        var retVal: [URLQueryItem] = []
        retVal.append(URLQueryItem(name: ZPIdentityClientDefaultParams.deviceOSVersion,
                                   value: UIDevice.current.systemVersion))
        retVal.append(URLQueryItem(name: ZPIdentityClientDefaultParams.deviceBundleVersion,
                                   value: UIApplication.appVersion()))
        retVal.append(URLQueryItem(name: ZPIdentityClientDefaultParams.deviceBundleID,
                                   value: APKeychain.bundleIdentifier()))
        return retVal
    }

    /// Default params to pass through URL to generate a new session token.
    var sessionURLQueryItems: [URLQueryItem] {
        var retVal: [URLQueryItem] = defaultURLQueryItems
        retVal.append(URLQueryItem(name: ZPIdentityClientSessionParams.deviceID,
                                   value: ZPIdentityClientBase.deviceID))
        retVal.append(URLQueryItem(name: ZPIdentityClientSessionParams.deviceToken,
                                   value: ZPIdentityClientBase.token))

        return retVal
    }

    /// Device string by device type
    var deviceType: String {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return ZPIdentityClientBaseKeys.iPadDeviceKey
        } else if UIDevice.current.userInterfaceIdiom == .tv {
            return ZPIdentityClientBaseKeys.tvDeviceKey
        } else {
            return ZPIdentityClientBaseKeys.iPhoneDeviceKey
        }
    }

    /// Default params to pass through URL to generate new device unique identifier
    var deviceURLQueryItems: [URLQueryItem] {
        var retVal: [URLQueryItem] = defaultURLQueryItems
        retVal.append(URLQueryItem(name: ZPIdentityClientDeviceParams.deviceModel,
                                   value: deviceType))
        retVal.append(URLQueryItem(name: ZPIdentityClientDeviceParams.deviceType,
                                   value: ZPIdentityClientDeviceParams.deviceTypeValue))
        return retVal
    }

    /// Create / Get new device unique identifier and token
    ///
    /// - Parameter completion: Completions with creation session result.
    @objc public func createDevice(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        if let deviceID = ZPIdentityClientBase.deviceID,
            let token = ZPIdentityClientBase.token,
            String.isNotEmptyOrWhitespace(deviceID),
            String.isNotEmptyOrWhitespace(token) {
            // If Credentials were found in the keychain - In case we are online - create a session.
            // Currently - session creation is not mandatory to UUID creation or use
            createSession()
            completion(true,
                       nil)
        } else {
            guard let createDeviceURLRequest = createURLRequest(from: createDeviceURL) else {
                let error = NSError(domain: errorMessageSessionCanNotCreate,
                                    code: -1,
                                    userInfo: nil)

                debugPrint(error)
                completion(false,
                           nil)
                return
            }

            let task = URLSession.shared.dataTask(with: createDeviceURLRequest) { data, _, error in
                DispatchQueue.main.async {
                    if let responseDict = self.dictFromData(data: data),
                        let uuid = responseDict[ZPIdentityClientBaseKeys.sessionResponseUUID] as? String,
                        String.isNotEmptyOrWhitespace(uuid),
                        let token = responseDict[ZPIdentityClientBaseKeys.sessionResponseToken] as? String {
                        // Synchronize
                        objc_sync_enter(self)

                        APKeychain.setString(uuid,
                                             forKey: ZPIdentityClientBase.serverType.UUIDKey)
                        APKeychain.setString(token,
                                             forKey: ZPIdentityClientBase.serverType.tokenKey)

                        objc_sync_exit(self)

                        self.createSession()
                        completion(true,
                                   error)
                        return
                    }

                    completion(false,
                               error)
                }
            }

            task.resume()
        }
    }

    /// Try to serealize data object to dictionary
    ///
    /// - Parameter data: Data object to parse
    /// - Returns: Dictonary if Data can be serealized, otherwise nil
    public func dictFromData(data: Data?) -> [String: Any]? {
        var retVal: [String: Any]?
        guard let data = data else {
            return retVal
        }

        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            if let jsonDict = jsonDict {
                retVal = jsonDict
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }

        return retVal
    }
}
