import SwiftUI

@MainActor
@Observable
final class AppViewModel {
  enum LoadState {
    case loading
    case success
    case failure(String)
  }

  var state: LoadState = .loading
  var episodes: [Episode] = []

  private let feedClient: FeedClient

  init(feedClient: FeedClient? = nil) {
    self.feedClient = feedClient ?? .live
  }

  func loadEpisodes() async {
    state = .loading

    do {
      let feed = try await feedClient.fetchFeed()
      episodes = feed.episodes
      state = .success

    } catch {
      state = .failure(error.localizedDescription)
    }
  }
}
