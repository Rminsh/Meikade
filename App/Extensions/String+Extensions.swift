//
//  String+Extensions.swift
//  Meikade
//
//  Created by Armin on 12/22/23.
//

import Foundation

extension String {
    var isRTL: Bool {
        let lang = CFStringTokenizerCopyBestStringLanguage(
            self as CFString,
            CFRange(location: 0, length: self.count)
        )

        if let lang {
            let direction = NSLocale.characterDirection(forLanguage: lang as String)
            return direction == .rightToLeft
        }
        
        return false
    }
}
