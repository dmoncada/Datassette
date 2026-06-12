import SwiftUI

struct PaddedPercentageFormatStyle: FormatStyle {
  let length: Int

  func format(_ value: Int) -> String {
    let number = String(value)
    let pad = String(repeating: " ", count: max(0, length - number.count))
    return "\(number)\(pad)%"
  }
}

extension FormatStyle where Self == PaddedPercentageFormatStyle {
  static func paddedPercent(length: Int) -> Self { .init(length: length) }
}
