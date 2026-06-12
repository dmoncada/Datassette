import Foundation

enum EpisodeFilter: String, CaseIterable, Identifiable {
  case all
  case favorites

  var id: Self { self }

  var title: String {
    switch self {
    case .all: "All"
    case .favorites: "Favorites"
    }
  }
}
