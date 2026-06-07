import Foundation

struct DatassetteFeed: Codable, Equatable {
  let title: String
  let description: String?
  let episodes: [Episode]
  let lastUpdated: Date?
}

extension DatassetteFeed {
  enum Error: LocalizedError {
    case contentUnavailable(String)
  }
}
