//
//  Api.swift
//
//  Created by Gints Murans on 15.08.16.
//  Copyright © 2016. g. 4Apps. All rights reserved.
//

import Foundation
import Alamofire
import NetworkExtension
import UIKit


typealias ApiCallback = (_ data: Any?, _ error: ApiError?)->()
typealias VpnStatusChangedCallback = (_ error: ApiError?)->()


enum ApiResponseType {
    case json
    case string
    case data
}


enum ApiError: Error, CustomStringConvertible {
    typealias RawValue = Int

    case vpnConfigurationError
    case vpnStartTunnelError(message: String)
    case apiEncodingError(message: String)
    case apiResponseError(message: String)
    case apiGeneralError(message: String, url: String?)

    var description: String {
        get {
            switch self {
            case .vpnConfigurationError:
                return "VPN configuration error"

            case .vpnStartTunnelError(let message):
                return "Error starting vnp connection: \(message)"

            case .apiResponseError(let message):
                return message

            case .apiGeneralError(let message, let url):
                return "There was an error while getting data.\nUrl: \(url == nil ? "" : url!).\nMessage: \(message)"

            case .apiEncodingError(let message):
                return "There was an error while sending data: \(message)"
            }
        }
    }
}


class BasicAuthAdapter: RequestAdapter {
    private let username: String
    private let password: String
    private let base64Auth: String

    init(username: String, password: String) {
        self.username = username
        self.password = password

        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        self.base64Auth = loginData.base64EncodedString()
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Basic \(self.base64Auth)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}


class Api {
    // MARK: - Singleton
    static let shared: Api = {
        return Api()
    }()

    // MARK: - Init
    fileprivate init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: OperationQueue.main, using: vpnStatusChanged)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Variables
    var domain = ""
    var username = ""
    var password = ""

    var vpnSaved = false
    var vpnStatus: NEVPNStatus {
        get {
            let manager = NEVPNManager.shared()
            return manager.connection.status
        }
    }
    var vpnConnectedCallback: VpnStatusChangedCallback?
    var networkAuthenticated = false


    // Set networking default policy
    lazy var networkManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            self.domain: .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            )
        ]

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        let manager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        manager.adapter = BasicAuthAdapter(username: self.username, password: self.password)

        return manager
    }()


    // MARK: - Helpers
    /*
     * Format: ["msg": ["code": XX, "text": "YY"]]
     */
    func testForErrorInJson(_ data: [String: Any]) -> (Int, String)? {
        if let error = data["msg"] as? NSDictionary {
            let code = error.object(forKey: "code") as? Int
            if code != nil && code! == 0 {
                return nil
            }

            guard let msg = error.object(forKey: "text") as? String else {
                return nil
            }

            return (code == nil ? 0 : code!, msg)
        }

        return nil
    }


    func showMsg(_ title: String, msg: String, vc: UIViewController? = nil, callback: (()->())? = nil) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: { (action: UIAlertAction) -> Void in
                        if let callback = callback {
                            callback()
                        }
                })
            )

            if let vc = vc {
                vc.present(alert, animated: true, completion: nil)
            } else if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                if let vc1 = rootVC.presentedViewController {
                    vc1.present(alert, animated: true, completion: nil)
                } else {
                    rootVC.present(alert, animated: true, completion: nil)
                }
            }
        })
    }


    // MARK: - VPN
    func vpnStatusChanged(_: Notification?) {
        if let vpnConnectedCallback = self.vpnConnectedCallback {
            switch self.vpnStatus {
            case .connected:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                vpnConnectedCallback(nil)
                self.vpnConnectedCallback = nil
                break

            case .disconnected:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                vpnConnectedCallback(ApiError.vpnStartTunnelError(message: "Could not connect to the vpn server"))
                self.vpnConnectedCallback = nil
                break

            case .connecting:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                break

            case .disconnecting:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                break

            case .invalid:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                break

            case .reasserting:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                break
            }
        }
    }


    func startVPN(_ callback: VpnStatusChangedCallback?) throws {
        #if (arch(i386) || arch(x86_64))
        if let callback = callback {
            callback(nil)
            return
        }
        #endif

        let manager = NEVPNManager.shared()

        if self.vpnStatus == .invalid {
            throw ApiError.vpnConfigurationError
        }

        if self.vpnStatus == .connected {
            if let callback = callback {
                callback(nil)
                return
            }
        }

        if self.vpnStatus == .disconnected {
            self.vpnConnectedCallback = callback

            do {
                try manager.connection.startVPNTunnel()
            } catch let error as NSError {
                var errorStr = ""
                switch error {
                case NEVPNError.configurationDisabled:
                    errorStr = "The VPN configuration associated with the NEVPNManager is disabled."
                    break
                case NEVPNError.configurationInvalid:
                    errorStr = "The VPN configuration associated with the NEVPNManager object is invalid."
                    break
                case NEVPNError.configurationReadWriteFailed:
                    errorStr = "An error occurred while reading or writing the Network Extension preferences."
                    break
                case NEVPNError.configurationStale:
                    errorStr = "The VPN configuration associated with the NEVPNManager object was modified by some other process since the last time that it was loaded from the Network Extension preferences by the app."
                    break
                case NEVPNError.configurationUnknown:
                    errorStr = "An unspecified error occurred."
                    break
                case NEVPNError.connectionFailed:
                    errorStr = "The connection to the VPN server failed."
                    break
                default:
                    errorStr = "Unknown error: \(error.localizedDescription)"
                    break
                }
                throw ApiError.vpnStartTunnelError(message: errorStr)
            }
            return
        }
    }


    // MARK: - Api requests
    func request(_ router: ApiRouter, postData: [String: Any]? = nil, returnType: ApiResponseType = ApiResponseType.json, callback: ApiCallback? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let request = networkManager.request(router)
        if returnType == ApiResponseType.data {
            request.responseData(completionHandler: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                if response.result.isFailure {
                    let apiError = ApiError.apiGeneralError(message: response.result.description, url: router.urlString)
                    if callback != nil {
                        callback!(response.data, apiError)
                    }
                    return
                }

                guard let callback = callback else {
                    return
                }

                if response.response?.statusCode == 200 {
                    callback(response.data, nil)
                    return
                }
            })
        } else if returnType == ApiResponseType.json {
            request.responseJSON(completionHandler: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                guard let callback = callback else {
                    return
                }

                if response.result.isSuccess {
                    if let JSON = response.result.value as? [String: Any] {
                        if let test = self.testForErrorInJson(JSON) {
                            let apiError = ApiError.apiResponseError(message: test.1)
                            callback(nil, apiError)
                            return
                        }

                        callback(JSON, nil)
                        return
                    }

                    let apiError = ApiError.apiResponseError(message: "Unknown error")
                    callback(nil, apiError)
                } else {
                    print(String(data: response.data!, encoding: String.Encoding.utf8)!) // server data
                    let apiError = ApiError.apiGeneralError(message: response.result.description, url: router.urlString)
                    callback(nil, apiError)
                }
            })
        }
    }


    func authenticateNetworkManager(_ callback: ApiCallback? = nil) {
        if self.vpnStatus == .connected && networkAuthenticated == true {
            if let callback = callback {
                callback(nil, nil)
            }
            return
        }

        do {
            try self.startVPN { (error) in
                if let error = error {
                    if let callback = callback {
                        callback(nil, error)
                    }
                    return
                }

                self.request(ApiRouter.authorize(), returnType: ApiResponseType.data) { (data, error) in
                    self.networkAuthenticated = (error == nil)

                    if let callback = callback {
                        callback(data, error)
                    }
                }
            }
        } catch (let error) {
            // Next one should always evaluate to true because startVPN if throws, its always ApiError
            if let error = error as? ApiError {
                if let callback = callback {
                    callback(nil, error)
                }
            }
        }
    }
}
