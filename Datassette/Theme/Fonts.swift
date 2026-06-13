import SwiftUI

#if canImport(AppKit)
  typealias PlatformFont = NSFont
  #elseif canImport(UIKit)
  typealias PlatformFont = UIFont
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
  static func baseSize(for textStyle: Font.TextStyle) -> CGFloat {
    #if canImport(AppKit)
      NSFontDescriptor
        .preferredFontDescriptor(forTextStyle: .init(textStyle))
        .pointSize

    #elseif canImport(UIKit) && !os(watchOS)
      UIFontDescriptor
        .preferredFontDescriptor(
          withTextStyle: .init(textStyle),
          compatibleWith: UITraitCollection(
            preferredContentSizeCategory: .large
          )
        )
        .pointSize

    #else
      UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .init(textStyle))
        .pointSize
    #endif
  }

  static func custom(_ name: String, _ textStyle: Font.TextStyle) -> Font {
    .custom(name, size: baseSize(for: textStyle), relativeTo: textStyle)
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

#if DEBUG
  private func installedFontNames(matching query: String) -> [String] {
    #if canImport(AppKit)
      NSFontManager.shared.availableFonts
        .filter { $0.localizedStandardContains(query) }
        .sorted()
    #elseif canImport(UIKit)
      PlatformFont.familyNames
        .flatMap { PlatformFont.fontNames(forFamilyName: $0) }
        .filter { $0.localizedStandardContains(query) }
        .sorted()
    #endif
  }

  private struct InstalledIbmPlexFontsList: View {
    let fontNames = installedFontNames(matching: "IBMPlex")

    var body: some View {
      List(fontNames, id: \.self) { name in
        Text(name)
          .font(.custom(name, size: 40, relativeTo: .largeTitle))
          .minimumScaleFactor(0.5)
          .scaledToFit()
      }
    }
  }

  private struct IbmPlexWeightSpecimen: View {
    let fontNames = installedFontNames(matching: "IBMPlex")

    var body: some View {
      List(fontNames, id: \.self) { name in
        VStack(alignment: .leading) {
          Text("hello")
            .font(.custom(name, size: 40, relativeTo: .largeTitle))
          Text(name)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
  }

  private struct IbmPlexThemeFontMatrix: View {
    private let weights: [(name: String, weight: Font.Weight)] = [
      ("ultraLight", .ultraLight),
      ("thin", .thin),
      ("light", .light),
      ("regular", .regular),
      ("medium", .medium),
      ("semibold", .semibold),
      ("bold", .bold),
      ("heavy", .heavy),
      ("black", .black),
    ]

    var body: some View {
      List(weights, id: \.name) { (name, weight) in
        VStack(alignment: .leading) {
          HStack {
            Text("hello")
              .font(.themeFont(.largeTitle).weight(weight))
            Text("hello")
              .font(.themeFont(.largeTitle).weight(weight).italic())
          }

          Text(name)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
  }

  #Preview("Installed") {
    InstalledIbmPlexFontsList()
  }

  #Preview("Weights & Styles") {
    IbmPlexWeightSpecimen()
  }

  #Preview("Extension") {
    IbmPlexThemeFontMatrix()
  }
#endif
