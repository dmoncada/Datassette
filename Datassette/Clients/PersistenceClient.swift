import Foundation

struct PersistenceClient: Sendable {
  var savePosition: @Sendable (_ episodeId: String, _ position: TimeInterval) -> Void
  var getPosition: @Sendable (_ episodeId: String) -> TimeInterval
  var saveLastEpisodeId: @Sendable (_ id: String) -> Void
  var getLastEpisodeId: @Sendable () -> String?
  var saveCachedFeed: @Sendable (_ feed: DatassetteFeed) -> Void
  var getCachedFeed: @Sendable () -> DatassetteFeed?
  var saveFavorites: @Sendable (_ favorites: Set<String>) -> Void
  var getFavorites: @Sendable () -> Set<String>
}

extension PersistenceClient {
  static var live: Self = {
    enum Keys {
      static let lastEpisodeId = "last_episode_id"
      static let cachedFeed = "cached_feed"
      static let playbackPositions = "playback_positions"
      static let favorites = "favorites"
    }

    @Sendable func positions() -> [String: TimeInterval] {
      UserDefaults.standard.dictionary(forKey: Keys.playbackPositions)
        as? [String: TimeInterval] ?? [:]
    }

    return PersistenceClient(
      savePosition: { id, position in
        var current = positions()
        current[id] = position
        UserDefaults.standard.set(current, forKey: Keys.playbackPositions)
      },
      getPosition: { id in
        positions()[id] ?? 0
      },
      saveLastEpisodeId: { id in
        UserDefaults.standard.set(id, forKey: Keys.lastEpisodeId)
      },
      getLastEpisodeId: {
        UserDefaults.standard.string(forKey: Keys.lastEpisodeId)
      },
      saveCachedFeed: { feed in
        if let data = try? JSONEncoder().encode(feed) {
          UserDefaults.standard.set(data, forKey: Keys.cachedFeed)
        }
      },
      getCachedFeed: {
        guard
          let data = UserDefaults.standard.data(forKey: Keys.cachedFeed),
          let feed = try? JSONDecoder().decode(DatassetteFeed.self, from: data)
        else { return nil }
        return feed
      },
      saveFavorites: { favorites in
        UserDefaults.standard.set(Array(favorites), forKey: Keys.favorites)
      },
      getFavorites: {
        Set(UserDefaults.standard.stringArray(forKey: Keys.favorites) ?? [])
      }
    )
  }()

  static let mock =
    Self(
      savePosition: { _, _ in },
      getPosition: { _ in 0 },
      saveLastEpisodeId: { _ in },
      getLastEpisodeId: { nil },
      saveCachedFeed: { _ in },
      getCachedFeed: { nil },
      saveFavorites: { _ in },
      getFavorites: { [] }
    )
}
