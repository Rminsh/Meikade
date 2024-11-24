//
//  ModelTests.swift
//  Meikade
//
//  Created by Armin on 11/18/24.
//

import Testing
import Foundation
@testable import Meikade

@Suite(.tags(.model))
struct ModelTests {
    @Test("Poem Decoding")
    func poem() async throws {
        let json: Data = String("""
        {
          "result": {
            "categories": [
              {
                "id": 10000619,
                "title": "اشعار"
              }
            ],
            "poem": {
              "id": 901750,
              "poet_id": 5723,
              "category_id": 10000619,
              "title": "Ah! why, because the dazzling sun",
              "phrase": null,
              "views": 191
            },
            "poet": {
              "id": 5723,
              "username": "امیلی برونته",
              "name": "امیلی برونته",
              "description": "null",
              "image": "",
              "wikipedia": "",
              "color": "",
              "views": 6511
            },
            "verses": [
              {
                "vorder": 1,
                "position": -5,
                "text": "Ah! why, because the dazzling sun"
              },
              {
                "vorder": 2,
                "position": -5,
                "text": "Restored my earth to joy"
              },
              {
                "vorder": 3,
                "position": -5,
                "text": "Have you departed, every one"
              },
              {
                "vorder": 4,
                "position": -5,
                "text": "And left a desert sky?"
              },
              {
                "vorder": 5,
                "position": -5,
                "text": "All through the night, your glorious eyes"
              },
              {
                "vorder": 6,
                "position": -5,
                "text": "Were gazing down in mine"
              },
              {
                "vorder": 7,
                "position": -5,
                "text": "And with a full heart's thankful sighs"
              },
              {
                "vorder": 8,
                "position": -5,
                "text": "I blessed that watch divine!"
              },
              {
                "vorder": 9,
                "position": -5,
                "text": "I was at peace, and drank your beams"
              },
              {
                "vorder": 10,
                "position": -5,
                "text": "As they were life to me"
              },
              {
                "vorder": 11,
                "position": -5,
                "text": "And revelled in my changeful dreams"
              },
              {
                "vorder": 12,
                "position": -5,
                "text": "Like petrel on the sea."
              },
              {
                "vorder": 13,
                "position": -5,
                "text": "Thought followed thoughtstar followed star"
              },
              {
                "vorder": 14,
                "position": -5,
                "text": "Through boundless regions on"
              },
              {
                "vorder": 15,
                "position": -5,
                "text": "While one sweet influence, near and far"
              },
              {
                "vorder": 16,
                "position": -5,
                "text": "Thrilled through and proved us one."
              },
              {
                "vorder": 17,
                "position": -5,
                "text": "Why did the morning rise to break"
              },
              {
                "vorder": 18,
                "position": -5,
                "text": "So great, so pure a spell"
              },
              {
                "vorder": 19,
                "position": -5,
                "text": "And scorch with fire the tranquil cheek"
              },
              {
                "vorder": 20,
                "position": -5,
                "text": "Where your cool radiance fell?"
              },
              {
                "vorder": 21,
                "position": -5,
                "text": "Blood-red he rose, and arrow-straight"
              },
              {
                "vorder": 22,
                "position": -5,
                "text": "His fierce beams struck my brow;"
              },
              {
                "vorder": 23,
                "position": -5,
                "text": "The soul of Nature sprang elate"
              },
              {
                "vorder": 24,
                "position": -5,
                "text": "But mine sank sad and low!"
              },
              {
                "vorder": 25,
                "position": -5,
                "text": "My lids closed downyet through their veil"
              },
              {
                "vorder": 26,
                "position": -5,
                "text": "I saw him blazing still;"
              },
              {
                "vorder": 27,
                "position": -5,
                "text": "And bathe in gold the misty dale"
              },
              {
                "vorder": 28,
                "position": -5,
                "text": "And flash upon the hill."
              },
              {
                "vorder": 29,
                "position": -5,
                "text": "I turned me to the pillow then"
              },
              {
                "vorder": 30,
                "position": -5,
                "text": "To call back Night, and see"
              },
              {
                "vorder": 31,
                "position": -5,
                "text": "Your worlds of solemn light, again"
              },
              {
                "vorder": 32,
                "position": -5,
                "text": "Throb with my heart and me!"
              },
              {
                "vorder": 33,
                "position": -5,
                "text": "It would not dothe pillow glowed"
              },
              {
                "vorder": 34,
                "position": -5,
                "text": "And glowed both roof and floor"
              },
              {
                "vorder": 35,
                "position": -5,
                "text": "And birds sang loudly in the wood"
              },
              {
                "vorder": 36,
                "position": -5,
                "text": "And fresh winds shook the door."
              },
              {
                "vorder": 37,
                "position": -5,
                "text": "The curtains waved, the wakened flies"
              },
              {
                "vorder": 38,
                "position": -5,
                "text": "Were murmuring round my room"
              },
              {
                "vorder": 39,
                "position": -5,
                "text": "Imprisoned there, till I should rise"
              },
              {
                "vorder": 40,
                "position": -5,
                "text": "And give them leave to roam."
              },
              {
                "vorder": 41,
                "position": -5,
                "text": "O Stars and Dreams and Gentle Night;"
              },
              {
                "vorder": 42,
                "position": -5,
                "text": "O Night and Stars return!"
              },
              {
                "vorder": 43,
                "position": -5,
                "text": "And hide me from the hostile light"
              },
              {
                "vorder": 44,
                "position": -5,
                "text": "That does not warm, but burn"
              },
              {
                "vorder": 45,
                "position": -5,
                "text": "That drains the blood of suffering men;"
              },
              {
                "vorder": 46,
                "position": -5,
                "text": "Drinks tears, instead of dew:"
              },
              {
                "vorder": 47,
                "position": -5,
                "text": "Let me sleep through his blinding reign"
              },
              {
                "vorder": 48,
                "position": -5,
                "text": "And only wake with you!"
              }
            ]
          }
        }
        """).data(using: .utf8)!
        let decoder: JSONDecoder = .init()
        let result: Poem = try decoder.decode(PoemResponse.self, from: json).result
        #expect(result.verses.count != 0)
        #expect(result.poem.title == "Ah! why, because the dazzling sun")
        #expect(result.verses.count == 48)
    }
}
