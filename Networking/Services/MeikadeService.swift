//
//  MeikadeService.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

protocol MeikadeServiceable {
    func getExplore() async throws -> Explore
}

struct MeikadeService: HTTPClient, MeikadeServiceable {
    func getExplore() async throws -> Explore {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.explore,
            responseModel: Explore.self
        )
    }
}
