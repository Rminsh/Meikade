//
//  EmptyState.swift
//  Meikade
//
//  Created by Armin on 12/27/23.
//

import Foundation

enum EmptyState: Equatable {
    case empty(icon: String, title: String)
    case network(subtitle: String)
    
    var icon: String {
        switch self {
        case .empty(let icon, _):
            return icon
        case .network:
            return "wifi.exclamationmark"
        }
    }
    
    var title: String {
        switch self {
        case .empty(_, let title):
            return title
        case .network:
            return "Connection error"
        }
    }
    
    var subtitle: String {
        switch self {
        case .empty:
            return ""
        case .network(let subtitle):
            return subtitle
        }
    }
    
    var showAction: Bool {
        switch self {
        case .empty:
            return false
        case .network:
            return true
        }
    }
}
