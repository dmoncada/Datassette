import Foundation

extension String {
  func removingPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

extension String {
  /// Builds an empty-state placeholder from a real label by replacing
  /// content characters with `fill`, keeping structural characters such as
  /// brackets so the placeholder stays on the same character grid.
  func placeholder(
    fill: Character = "-",
    keeping kept: Set<Character> = ["[", "]", ":", " "],
  ) -> String {
    String(map { kept.contains($0) ? $0 : fill })
  }
}

extension String {
  func breakLine(after separator: String) -> [String] {
    guard let range = self.range(of: separator)
    else { return [self] }

    return [
      String(self[..<range.upperBound]),
      String(self[range.upperBound...]).trimmingCharacters(in: .whitespaces),
    ]
  }
}

extension AttributedString {
  func breakLine(_ width: Int, trimLeadingWhitespace: Bool = true) -> [AttributedString] {
    guard width > 0 else { return [] }

    let text = self
    var result: [AttributedString] = []
    var start = text.startIndex
    var current = start
    var count = 0

    while current < text.endIndex {
      let next = text.index(afterCharacter: current)

      count += 1

      if count > width {
        result.append(AttributedString(text[start ..< current]))

        start = current
        count = 0

        if trimLeadingWhitespace {
          while start < text.endIndex {
            let next = text.index(afterCharacter: start)
            let first = text[start ..< next].characters.first

            guard first?.isWhitespace == true
            else { break }

            start = next
          }
        }

        current = start
        continue
      }

      current = next
    }

    if start < text.endIndex {
      result.append(AttributedString(text[start...]))
    }

    return result
  }
}
