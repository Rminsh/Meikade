//
//  Verse+Extensions.swift
//  Meikade
//
//  Created by Armin on 1/11/24.
//

import SwiftUI

extension Verse {
    var nsPosition: NSTextAlignment {
        switch position {
        case 0:
            return .right
        case 1:
            return .left
        case 2:
            return .center
        case -5:
            return .left
        default:
            return .right
        }
    }
    
    var alignment: Alignment {
        switch position {
        case 0:
            return .leading
        case 1:
            return .trailing
        case 2:
            return .center
        case -5:
            return .leading
        default:
            return .leading
        }
    }
}
