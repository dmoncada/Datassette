import SwiftUI

#if canImport(AppKit)
  typealias PlatformFont = NSFont
  typealias FontDescriptor = NSFontDescriptor
#elseif canImport(UIKit)
  typealias PlatformFont = UIFont
  typealias FontDescriptor = UIFontDescriptor
#endif

extension PlatformFont.TextStyle {
  init(_ textStyle: Font.TextStyle) {
    switch textStyle {
    case .largeTitle:
      #if os(tvOS)
        self = .title1
      #else
        self = .largeTitle
      #endif
    case .title:
      self = .title1
    case .title2:
      self = .title2
    case .title3:
      self = .title3
    case .headline:
      self = .headline
    case .subheadline:
      self = .subheadline
    case .body:
      self = .body
    case .callout:
      self = .callout
    case .footnote:
      self = .footnote
    case .caption:
      self = .caption1
    case .caption2:
      self = .caption2
    #if os(visionOS)
      case .extraLargeTitle:
        self = .extraLargeTitle
      case .extraLargeTitle2:
        self = .extraLargeTitle2
    #endif
    @unknown default:
      self = .body
    }
  }
}

extension Font {
  static func custom(_ name: String, _ textStyle: Font.TextStyle) -> Font {
    let baseSize: CGFloat

    #if canImport(AppKit)
      baseSize =
        NSFontDescriptor
        .preferredFontDescriptor(forTextStyle: .init(textStyle))
        .pointSize

    #elseif canImport(UIKit) && !os(watchOS)
      baseSize =
        UIFontDescriptor
        .preferredFontDescriptor(
          withTextStyle: .init(textStyle),
          compatibleWith: UITraitCollection(
            preferredContentSizeCategory: .large
          )
        )
        .pointSize

    #else
      baseSize =
        UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .init(textStyle))
        .pointSize
    #endif

    return .custom(name, size: baseSize, relativeTo: textStyle)
  }
}

extension Font {
  static func themeFont(size: CGFloat) -> Font {
    .custom("IBMPlexMono", size: size)
  }

  static func themeFont(_ textStyle: Font.TextStyle) -> Font {
    .custom("IBMPlexMono", textStyle)
  }
}
