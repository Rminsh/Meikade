//
//  EndpointTests.swift
//  MeikadeTests
//
//  Created by Armin on 11/16/24.
//

import Testing
@testable import Meikade

@Suite("API Endpoint Test")
struct EndpointTests {
    @Test(arguments: [MeikadeEndpoint.home, .explore, .poetTypes])
    func methodType(_ endpoint: MeikadeEndpoint) async throws {
        #expect(endpoint.method == .get)
    }
    
    @Test(
        arguments: [
            MeikadeEndpoint.home,
            .explore,
            .poetTypes,
            .category(categoryID: 1),
            .poet(poetID: 1)
        ]
    )
    func inputs(_ endpoint: MeikadeEndpoint) async throws {
        #expect(endpoint.header == nil)
        #expect(endpoint.body == nil)
        #expect(endpoint.needsToken == false)
    }
    
    @Test("Home") func homeEndpoint() async throws {
        let endpoint = MeikadeEndpoint.home
        #expect(endpoint.method == .get)
        #expect(endpoint.path == "/api/main/home")
        #expect(endpoint.body == nil)
        #expect(endpoint.urlParams == nil)
    }
    
    @Test("Poets") func poetEndpoint() async throws {
        let endpoint = MeikadeEndpoint.poets(limit: 10, offset: 0, typeID: 1)
        #expect(endpoint.method == .get)
        #expect(endpoint.path == "/api/main/poets")
        #expect(endpoint.body == nil)
        #expect(endpoint.urlParams == [
            .init(name: "limit", value: String(10)),
            .init(name: "offset", value: String(0)),
            .init(name: "type_id", value: String(1))
        ])
    }
}
