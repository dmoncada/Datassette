import FeedKit
import SwiftUI
internal import XMLKit
import os

extension Logger.Datassette.Category {
  fileprivate static let feedClient = Self(rawValue: "feedClient")
}

struct FeedClient: Sendable {
  var fetchFeed: @Sendable () async throws -> DatassetteFeed
}

extension FeedClient {
  static var live: Self = {
    let feedUrl = "https://musicforprogramming.net/rss.xml"
    let logger = Logger(category: .feedClient)

    return FeedClient(
      fetchFeed: {
        do {
          let rss = try await RSSFeed(urlString: feedUrl)

          let episodes: [Episode] =
            rss.channel?.items?.compactMap { item -> Episode? in
              guard let guid = item.guid?.text
              else { return nil }

              guard
                let urlString = item.enclosure?.attributes?.url,
                let url = URL(string: urlString)
              else { return nil }

              return Episode(
                id: guid,
                title: item.title ?? "Unknown",
                publicationDate: item.pubDate ?? Date(),
                enclosureURL: url,
                duration: item.iTunes?.duration.map(Duration.seconds),
                description: item.description
              )
            } ?? []

          return DatassetteFeed(
            title: rss.channel?.title ?? "Music for Programming",
            description: rss.channel?.description,
            episodes: episodes,
            lastUpdated: Date()
          )

        } catch {
          logger.error("Error fetching feed: \(error.localizedDescription)")
          throw error
        }
      }
    )
  }()

  static var mock: Self = {
    let feed = DatassetteFeed(
      title: "Music for Programming",
      description: "Music to help you focus while programming",
      episodes: [
        Episode(
          id: "78",
          title: "Episode 78: Datassette",
          publicationDate: Date(),
          enclosureURL: URL(
            string: "https://datashat.net/music_for_programming_78-datassette.mp3")!,
          duration: Duration.seconds(5400),
          description: nil
        ),
        Episode(
          id: "77",
          title: "Episode 77: Phonaut",
          publicationDate: Date(),
          enclosureURL: URL(string: "https://datashat.net/music_for_programming_77-phonaut.mp3")!,
          duration: Duration.seconds(7200),
          description: nil
        ),
        Episode(
          id: "7",
          title: "Episode 07: Tahlhoff Garten + Untitled",
          publicationDate: Date(),
          enclosureURL: URL(
            string: "https://datashat.net/music_for_programming_7-tahlhoff_garten_and_untitled.mp3")!,
          duration: Duration.seconds(4019),
          description: nil
        ),
      ],
      lastUpdated: Date()
    )

    return FeedClient(fetchFeed: { feed })
  }()

  static var failing: FeedClient = {
    FeedClient(
      fetchFeed: {
        throw DatassetteFeed.Error.contentUnavailable(
          "Preview: feed unavailable"
        )
      }
    )
  }()
}
