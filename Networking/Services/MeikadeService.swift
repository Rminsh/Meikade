//
//  MeikadeService.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

protocol MeikadeServiceable {
    func getExplore() async throws -> [ExploreSection]
    
    // MARK: - Poems
    func getPoem(poemID: Int, verseLimit: Int, verseOffset: Int) async throws -> Poem
    func getPoems(poetID: Int, categoryID: Int, offset: Int) async throws -> [PoemDetail]
    func getRandomPoem(verseLimit: Int, verseOffset: Int, poetID: Int?) async throws -> Poem
    func getVerses(poemID: Int) async throws -> [Verse]
    
    // MARK: - Poets
    func getPoetTypes() async throws -> [PoetType]
    func getPoets(limit: Int, offset: Int, typeID: Int) async throws -> [PoetItem]
    func getPoet(poetID: Int) async throws -> Poet
    
    // MARK: - Categories
    func getCategories(poetID: Int, parentID: Int?) async throws -> [Category]
    func getCategory(categoryID: Int) async throws -> CategoryResult
}

struct MeikadeService: HTTPClient, MeikadeServiceable {
    func getExplore() async throws -> [ExploreSection] {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.explore,
            responseModel: Explore.self
        ).sections
    }
    
    // MARK: - Poems
    func getPoem(poemID: Int, verseLimit: Int, verseOffset: Int) async throws -> Poem {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.poem(poemID: poemID, verseLimit: verseLimit, verseOffset: verseOffset),
            responseModel: PoemResponse.self
        ).result
    }
    
    func getPoems(poetID: Int, categoryID: Int, offset: Int) async throws -> [PoemDetail] {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.poems(poetID: poetID, categoryID: categoryID, offset: offset),
            responseModel: PoemsResponse.self
        ).result
    }
    
    func getRandomPoem(verseLimit: Int, verseOffset: Int, poetID: Int? = nil) async throws -> Poem {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.randomPoem(verseLimit: verseLimit, verseOffset: verseOffset, poetID: poetID),
            responseModel: PoemResponse.self
        ).result
    }
    
    func getVerses(poemID: Int) async throws -> [Verse] {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.verses(poemID: poemID),
            responseModel: VersesResponse.self
        ).result
    }
    
    // MARK: - Poets
    func getPoetTypes() async throws -> [PoetType] {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.poetTypes,
            responseModel: PoetTypesResponse.self
        ).result
    }
    
    func getPoets(limit: Int, offset: Int, typeID: Int) async throws -> [PoetItem] {
        let response = try await sendRequest(
            endpoint: MeikadeEndpoint.poets(limit: limit, offset: offset, typeID: typeID),
            responseModel: PoetsResponse.self
        )
        
        return response.result.first?.modelData ?? []
    }
    
    func getPoet(poetID: Int) async throws -> Poet {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.poet(poetID: poetID),
            responseModel: PoetResponse.self
        ).result
    }
    
    // MARK: - Categories
    func getCategories(poetID: Int, parentID: Int?) async throws -> [Category] {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.categories(poetID: poetID, parentID: parentID),
            responseModel: CategoriesResponse.self
        ).result.first?.modelData ?? []
    }
    
    func getCategory(categoryID: Int) async throws -> CategoryResult {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.category(categoryID: categoryID),
            responseModel: CategoryResult.self
        )
    }
}
