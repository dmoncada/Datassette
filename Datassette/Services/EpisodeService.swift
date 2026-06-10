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

  private(set) var favorites: Set<Episode.ID> = [] {
    didSet {
      if oldValue != favorites {
        persistence.saveFavorites(favorites)
      }
    }
  }

  private let feedClient: FeedClient
  private let persistence: PersistenceClient

  init(
    feedClient: FeedClient? = nil,
    persistence: PersistenceClient? = nil
  ) {
    self.feedClient = feedClient ?? .live
    self.persistence = persistence ?? .live
    self.favorites = self.persistence.getFavorites()
  }

  func loadEpisodes() async {
    state = .loading

    do {
      let feed = try await feedClient.fetchFeed()
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

  func getNext(for episode: Episode) -> Episode? {
    guard
      let index = episodes.firstIndex(of: episode),
      index < episodes.count - 1
    else { return nil }

    return episodes[index + 1]
  }

  func getPrev(for episode: Episode) -> Episode? {
    guard
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
