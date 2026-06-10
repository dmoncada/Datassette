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
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    enum Keys {
      static let lastEpisodeId = "last_episode_id"
      static let cachedFeed = "cached_feed"
      static let playbackPositions = "playback_positions"
      static let favorites = "favorites"
    }

    func positions() -> [String: TimeInterval] {
      defaults.dictionary(forKey: Keys.playbackPositions) as? [String: TimeInterval] ?? [:]
    }

    return PersistenceClient(
      savePosition: { id, position in
        var current = positions()
        current[id] = position
        defaults.set(current, forKey: Keys.playbackPositions)
      },
      getPosition: { id in
        positions()[id] ?? 0
      },
      saveLastEpisodeId: { id in
        defaults.set(id, forKey: Keys.lastEpisodeId)
      },
      getLastEpisodeId: {
        defaults.string(forKey: Keys.lastEpisodeId)
      },
      saveCachedFeed: { feed in
        if let data = try? encoder.encode(feed) {
          defaults.set(data, forKey: Keys.cachedFeed)
        }
      },
      getCachedFeed: {
        guard
          let data = defaults.data(forKey: Keys.cachedFeed),
          let feed = try? decoder.decode(DatassetteFeed.self, from: data)
        else { return nil }
        return feed
      },
      saveFavorites: { favorites in
        defaults.set(Array(favorites), forKey: Keys.favorites)
      },
      getFavorites: {
        Set(defaults.stringArray(forKey: Keys.favorites) ?? [])
      }
    )
  }()

  static var mock: Self = {
    var positions: [String: TimeInterval] = [:]
    var lastId: String? = nil
    var cachedFeed: DatassetteFeed? = nil
    var favorites: Set<String> = []

    return PersistenceClient(
      savePosition: { id, position in positions[id] = position },
      getPosition: { id in positions[id] ?? 0 },
      saveLastEpisodeId: { id in lastId = id },
      getLastEpisodeId: { lastId },
      saveCachedFeed: { feed in cachedFeed = feed },
      getCachedFeed: { cachedFeed },
      saveFavorites: { _ in },
      getFavorites: { [] }
    )
  }()
}
