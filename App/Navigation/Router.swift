//
//  Router.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import SwiftUI
import RegexBuilder

enum Router {
    case poetTypes
    case allPoets(typeID: Int)
    case poet(poetID: Int)
    
    case category(categoryID: Int)
    case categories(poetID: Int, parentID: Int)
    
    case poem(poemID: Int)
    case randomPoem
    case hafizFaal
    case verses(poemID: Int)
}

extension Router {
    static let poemRegex = /page\:\/poet\?id\=(\d+).+poemId\=(\d+)/
    static let onlineList = /popup\:\/lists\/online\?listId\=(\d+)/
    
    static func parse(link: String) -> Router? {
        if let result = link.wholeMatch(of: poemRegex), let poemID = Int(result.2) {
            return .poem(poemID: poemID)
        } else {
            return nil
        }
    }
}
    
struct RouterView {
    
    var link: String? = nil
    @State var route: Router? = nil
    
    func getRoute(link: String) -> Router? {
        switch link {
        case "page:/poets":
            return .allPoets(typeID: 0)
        case "page:/poem/random":
            return .randomPoem
        case "page:/poem/hafiz_faal":
            return .hafizFaal
        default:
            return Router.parse(link: link)
        }
    }
}

extension RouterView: View {
    var body: some View {
        Group {
            switch route {
            case .allPoets:
                PoetsListView()
            case .randomPoem:
                PoemView(poemType: .random())
            case .hafizFaal:
                PoemView(poemType: .poem(id: Int.random(in: 2130..<2625)))
            case .poem(let poemID):
                PoemView(poemType: .poem(id: poemID))
            default:
                EmptyStateView(
                    icon: "book.and.wrench",
                    title: "Nothing here",
                    description: "Page not found: \(link ?? "")"
                )
            }
        }
        .task {
            if let link {
                route = getRoute(link: link)
            }
        }
    }
}
