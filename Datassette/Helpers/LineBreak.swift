import Foundation

func breakIntoLines(
  _ text: AttributedString,
  lineWidth: Int,
  trimLeadingWhitespace: Bool = true
) -> [AttributedString] {
  guard lineWidth > 0 else { return [] }

  var result: [AttributedString] = []
  var start = text.startIndex
  var current = start
  var count = 0

  while current < text.endIndex {
    let next = text.index(afterCharacter: current)

    count += 1

    if count > lineWidth {
      result.append(AttributedString(text[start..<current]))

      start = current
      count = 0

      if trimLeadingWhitespace {
        while start < text.endIndex {
          let nextStart = text.index(afterCharacter: start)

          if !text[start..<nextStart]
            .characters
            .first!
            .isWhitespace
          {
            break
          }

          start = nextStart
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
