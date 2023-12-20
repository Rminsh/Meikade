//
//  Endpoint.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

public protocol Endpoint {
    var baseURL:    String            { get }
    var path:       String            { get }
    var method:     HTTPMethod        { get }
    var baseHeader: [String: String]  { get }
    var header:     [String: String]? { get }
    var urlParams:  [URLQueryItem]?   { get }
    var body:       [String: Any]?    { get }
    var needsToken: Bool              { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.meikade.com"
    }
    
    var baseHeader: [String: String] {
        return [:]
    }
    
    var needsToken: Bool {
        return false
    }
}
