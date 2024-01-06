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
    static let categoriesRegex = /page\:\/poet\?id\=(\d+).+catId\=(\d+)/
    
    static func parse(link: String) async -> Router? {
        if let result = link.wholeMatch(of: poemRegex), let poemID = Int(result.2) {
            return .poem(poemID: poemID)
        } else if let result = link.wholeMatch(of: categoriesRegex), let poetID = Int(result.1), let catID = Int(result.2) {
            return .categories(poetID: poetID, parentID: catID)
        } else {
            return nil
        }
    }
}
    
struct RouterView {
    var link: String? = nil
    var title: String? = nil
    @State var loading: Bool = true
    @State var route: Router? = nil
    
    func getRoute(link: String) async -> Router? {
        switch link {
        case "page:/poets":
            return .allPoets(typeID: 0)
        case "page:/poem/random":
            return .randomPoem
        case "page:/poem/hafiz_faal",
             "page:/poet?id=2\u{0026}catId=10001":
            return .hafizFaal
        default:
            return await Router.parse(link: link)
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
                HafezFaalView()
            case .poem(let poemID):
                PoemView(poemType: .poem(id: poemID))
            case .categories(let poetID, let parentID):
                CatrgoriesListView(poetID: poetID, categoryID: parentID, title: title ?? "")
            default:
                emptyState
            }
        }
        .task {
            if let link {
                route = await getRoute(link: link)
            }
            loading = false
        }
    }
    
    var emptyState: some View {
        Group {
            if loading {
                ProgressView()
            } else {
                EmptyStateView(
                    icon: "book.and.wrench",
                    title: "Nothing here",
                    description: "Page not found: \(link ?? "")"
                )
            }
        }
    }
}
