//
//  ApiRouter.swift
//
//  Created by Gints Murans on 15.08.16.
//  Copyright © 2016. g. 4Apps. All rights reserved.
//

import Foundation
import Alamofire
import NetworkExtension

enum ApiRouter: URLRequestConvertible {
    case authorize()
    case users()
    case units
    case unitDetails(eanCode: String)
    case findPallet(palletNumber: String)
    case upload(data: [String: Any])

    static let baseURLString = "https://\(Config.api.domain)"

    var method: HTTPMethod {
        switch self {
        // GET
        case .authorize:
            fallthrough
        case .users:
            return .get

        // POST
        case .upload:
            return .post
        }
    }

    var path: String {
        switch self {
        case .authorize:
            return "/settings/auth/basic"
        case .users:
            return "/inventory/api/users"
        case .upload:
            return "/inventory/api/upload"
        }
    }

    var describing: String {
        return urlString
    }

    var urlString: String {
        return "\(ApiRouter.baseURLString)\(path)"
    }

    func asURLRequest() throws -> URLRequest {
        let url = try ApiRouter.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .upload(let data):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: data)
        default:
            break
        }

        return urlRequest
    }
}

var unitsCache = CacheObject(name: "ApiUnits")

extension Api {
    func loadUsers(callback: ApiCallback? = nil) {
        // Request
        let innerCallback: ApiCallback = { (data, error) in
            if let error = error {
                if let callback = callback {
                    callback(nil, error)
                }
                return
            }

            self.request(ApiRouter.users()) { (data, error) in
                if error != nil {
                    if let callback = callback {
                        callback(nil, error)
                    }
                    return
                }

                guard let dataC = data as? [String: Any] else {
                    print(data!)
                    if let callback = callback {
                        callback(nil, ApiError.apiGeneralError(message: "There was an Unknown issue with data", url: nil))
                    }

                    return
                }

                guard let items = dataC["items"] as? [[String: Any]] else {
                    if let callback = callback {
                        callback(nil, ApiError.apiGeneralError(message: "There was an Unknown issue with data", url: nil))
                    }
                    return
                }

                if let callback = callback {
                    callback(items, nil)
                }
            }
        }

        // Authenticate first then call all those callbacks
        self.authenticateNetworkManager(innerCallback)
    }

    func upload(_ postData: [String: Any], callback: ApiCallback?) {
        // Request
        let innerCallback: ApiCallback = { (data, error) in
            if let error = error {
                if let callback = callback {
                    callback(nil, error)
                }
                return
            }

            self.request(ApiRouter.upload(data: postData), returnType: .json, callback: { (data, error) in
                guard let callback = callback else {
                    return
                }

                if error != nil {
                    callback(nil, error)
                    return
                }

                callback(data, nil)
            })
        }

        // Authenticate first then call all those callbacks
        self.authenticateNetworkManager(innerCallback)
    }
}
