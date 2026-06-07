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
              guard
                let guid = item.guid?.text
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
                duration: item.iTunes?.duration,
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
          print(error.localizedDescription)
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
          id: "66",
          title: "Episode 66: Conrad Clipper",
          publicationDate: Date(),
          enclosureURL: URL(string: "https://example.com/mfp66.mp3")!,
          duration: 4939,
          description: nil
        ),
        Episode(
          id: "65",
          title: "Episode 65: Dev/Null",
          publicationDate: Calendar.current.date(
            byAdding: .month,
            value: -1,
            to: Date()
          ) ?? Date(),
          enclosureURL: URL(string: "https://example.com/mfp65.mp3")!,
          duration: 5400,
          description: nil
        ),
        Episode(
          id: "64",
          title: "Episode 64: Escape Sequence",
          publicationDate: Calendar.current.date(
            byAdding: .month,
            value: -2,
            to: Date()
          ) ?? Date(),
          enclosureURL: URL(string: "https://example.com/mfp64.mp3")!,
          duration: 3720,
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
