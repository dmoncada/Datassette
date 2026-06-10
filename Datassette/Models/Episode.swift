import Foundation

struct Episode: Codable, Identifiable, Equatable {
  let id: String
  let title: String
  let publicationDate: Date
  let enclosureURL: URL
  let duration: Duration?
  let description: String?
}
