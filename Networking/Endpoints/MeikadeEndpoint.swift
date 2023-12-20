//
//  MeikadeEndpoint.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

enum MeikadeEndpoint {
    case explore
}

extension MeikadeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .explore:
            return "/api/main/explore"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .explore:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .explore:
            return ["Accept-Language": "fa"]
        }
    }
    
    var urlParams: [URLQueryItem]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
}
