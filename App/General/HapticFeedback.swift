//
//  HapticFeedback.swift
//  Meikade
//
//  Created by Armin on 8/15/23.
//

#if os(iOS)
import UIKit

struct HapticFeedback {
    
    static let shared = HapticFeedback()
    
    enum HapticType {
        case light
        case medium
        case heavy
        case soft
        case rigid
        case success
        case error
        case warning
    }
    
    @MainActor
    func start(_ type: HapticType) -> Void {
        switch type {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .soft:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        case .rigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}
#endif
