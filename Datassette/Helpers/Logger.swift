import os

extension Logger {
  enum Datassette {
    struct Category: RawRepresentable, Hashable {
      let rawValue: String
    }
  }

  private enum Constants {
    static let subsystem = "com.dmoncada.Datassette"
  }

  init(category: Datassette.Category) {
    self.init(subsystem: Constants.subsystem, category: category.rawValue)
  }
}
