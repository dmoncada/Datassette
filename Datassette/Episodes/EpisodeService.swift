import SwiftUI

@MainActor
@Observable
final class EpisodeService {
  enum LoadState {
    case loading
    case success
    case failure(String)
  }

  private(set) var state: LoadState = .loading
  private(set) var episodes: [Episode] = []

  var searchText = ""
  var filter: EpisodeFilter = .all

  var filteredEpisodes: [Episode] {
    var filtered = episodes

    if filter == .favorites {
      filtered = filtered.filter { favorites.contains($0.id) }
    }

    if searchText.count > 0 {
      filtered = filtered.filter {
        $0.title.localizedStandardContains(searchText)
      }
    }

    return filtered
  }

  private(set) var favorites: Set<Episode.ID> = [] {
    didSet {
      if oldValue != favorites {
        persistenceClient.saveFavorites(favorites)
      }
    }
  }

  private let episodeClient: EpisodeClient
  private let persistenceClient: PersistenceClient

  init(
    client: EpisodeClient = .live,
    persistence: PersistenceClient = .live
  ) {
    self.episodeClient = client
    self.persistenceClient = persistence
    self.favorites = self.persistenceClient.getFavorites()
  }

  func load() async {
    state = .loading

    do {
      let feed = try await episodeClient.fetch()
      episodes = feed.episodes
      state = .success

      let validIds = Set(feed.episodes.map(\.id))
      let pruned = favorites.intersection(validIds)
      if pruned != favorites {
        favorites = pruned
      }

    } catch {
      state = .failure(error.localizedDescription)
    }
  }

  func isFavorite(_ episode: Episode) -> Bool {
    favorites.contains(episode.id)
  }

  func toggleFavorite(_ episode: Episode) {
    if episodes.firstIndex(of: episode) == nil { return }
    if favorites.remove(episode.id) == nil {
      favorites.insert(episode.id)
    }
  }

  func getNext(for episode: Episode?) -> Episode? {
    guard
      let episode,
      let index = episodes.firstIndex(of: episode),
      index < episodes.count - 1
    else { return nil }

    return episodes[index + 1]
  }

  func getPrev(for episode: Episode?) -> Episode? {
    guard
      let episode,
      let index = episodes.firstIndex(of: episode),
      index > 0
    else { return nil }

    return episodes[index - 1]
  }

  func getRandom() -> Episode? {
    episodes.count > 0
      ? episodes.randomElement()
      : nil
  }
}
