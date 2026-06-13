import SwiftUI

struct PaddedPercentageFormatStyle: FormatStyle {
  let length: Int

  func format(_ value: Int) -> String {
    let number = String(value)
    let count = max(0, length - number.count)
    let pad = String(repeating: " ", count: count)
    return "\(number)\(pad)%"
  }
}

extension FormatStyle where Self == PaddedPercentageFormatStyle {
  static func percent(padPercentageToLength length: Int) -> Self { .init(length: length) }
}
