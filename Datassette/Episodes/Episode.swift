import Foundation

struct Episode: Codable, Identifiable, Equatable {
  let id: String
  let title: String
  let publicationDate: Date
  let enclosureURL: URL
  let duration: Duration?
  let description: String?
}

extension Episode {
  var episodeName: String {
    String(title.split(separator: ":")[1].trimmingCharacters(in: .whitespaces))
  }

  var episodeNumber: String {
    String(title.split(separator: ":")[0])
  }
}
