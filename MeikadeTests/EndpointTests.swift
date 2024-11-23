//
//  EndpointTests.swift
//  MeikadeTests
//
//  Created by Armin on 11/16/24.
//

import Testing
@testable import Meikade

struct EndpointTests {
    @Test(arguments: [MeikadeEndpoint.home, .explore, .poetTypes])
    func methodType(_ endpoint: MeikadeEndpoint) async throws {
        #expect(endpoint.method == .get)
    }
    
    @Test(arguments: [MeikadeEndpoint.home, .poetTypes/*, .explore*/])
    func header(_ endpoint: MeikadeEndpoint) async throws {
        #expect(endpoint.header == nil)
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
