import FeedKit
import SwiftUI
internal import XMLKit
import os

extension Logger.Datassette.Category {
  fileprivate static let feedClient = Self(rawValue: "feedClient")
}

struct EpisodeClient: Sendable {
  var fetch: @Sendable () async throws -> DatassetteFeed
}

extension EpisodeClient {
  static var live: Self =
    Self(
      fetch: {
        let logger = await Logger(category: .feedClient)
        let feedUrl = "https://musicforprogramming.net/rss.xml"

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

  static let mock =
    Self(
      fetch: {
        DatassetteFeed(
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
              enclosureURL: URL(
                string: "https://datashat.net/music_for_programming_77-phonaut.mp3")!,
              duration: Duration.seconds(7200),
              description: nil
            ),
            Episode(
              id: "7",
              title: "Episode 07: Tahlhoff Garten + Untitled",
              publicationDate: Date(),
              enclosureURL: URL(
                string:
                  "https://datashat.net/music_for_programming_7-tahlhoff_garten_and_untitled.mp3")!,
              duration: Duration.seconds(4019),
              description: nil
            )
          ],
          lastUpdated: Date()
        )
      })

  static let failing =
    Self(
      fetch: {
        throw DatassetteFeed.Error.contentUnavailable(
          "Preview: feed unavailable"
        )
      }
    )
}
