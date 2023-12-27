//
//  MeikadeService.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

protocol MeikadeServiceable {
    func getExplore() async throws -> Explore
    
    // MARK: - Poems
    func getPoem(poemID: Int, verseLimit: Int, verseOffset: Int) async throws -> Poem
    func getPoems(poetID: Int, categoryID: Int, offset: Int) async throws -> [PoemDetail]
    func getRandomPoem(verseLimit: Int, verseOffset: Int, poetID: Int?) async throws -> Poem
    func getVerses(poemID: Int) async throws -> [Verse]
    
    // MARK: - Poets
    func getPoetTypes() async throws -> [PoetTypes]
}

struct MeikadeService: HTTPClient, MeikadeServiceable {
    func getExplore() async throws -> Explore {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.explore,
            responseModel: Explore.self
        )
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
    func getPoetTypes() async throws -> [PoetTypes] {
        return try await sendRequest(
            endpoint: MeikadeEndpoint.poetTypes,
            responseModel: PoetTypesResponse.self
        ).result
    }
}
