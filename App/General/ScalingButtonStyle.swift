//
//  ScalingButtonStyle.swift
//  Meikade
//
//  Created by Armin on 1/6/24.
//

import SwiftUI

struct ScalingButtonStyle: ButtonStyle {
    var scale = CGFloat(0.95)
    func makeBody(configuration: Configuration) -> some View {
        var animation: Animation?

        if configuration.isPressed {
            /// pressing down
            animation = .spring(
                response: 0.19,
                dampingFraction: 0.45,
                blendDuration: 1
            )
        } else {
            animation = .spring(
                response: 0.4,
                dampingFraction: 0.4,
                blendDuration: 1
            )
        }

        return configuration.label
            .opacity(configuration.isPressed ? 0.95 : 1)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(animation, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScalingButtonStyle {
    static var scaling: ScalingButtonStyle {
        ScalingButtonStyle()
    }

    static func scaling(_ scale: CGFloat) -> ScalingButtonStyle {
        ScalingButtonStyle(scale: scale)
    }
}
