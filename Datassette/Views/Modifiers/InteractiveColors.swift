import SwiftUI

struct InteractiveColors {
  let activeForeground: Color
  let activeBackground: Color
  let inactiveForeground: Color
  let inactiveBackground: Color

  init(
    activeForeground: Color,
    activeBackground: Color,
    inactiveForeground: Color,
    inactiveBackground: Color
  ) {
    self.activeForeground = activeForeground
    self.activeBackground = activeBackground
    self.inactiveForeground = inactiveForeground
    self.inactiveBackground = inactiveBackground
  }

  init(accent: Color) {
    self.activeForeground = .themeBlack
    self.activeBackground = accent
    self.inactiveForeground = accent
    self.inactiveBackground = .clear
  }
}

extension InteractiveColors {
  static var themeGreen = Self(accent: .themeGreen)
  static var themeYellow = Self(accent: .themeYellow)
  static var themePurple = Self(accent: .themePurple)
}

struct InteractiveColorsModifier: ViewModifier {
  let isActive: Bool
  let colors: InteractiveColors

  func body(content: Content) -> some View {
    content
      .foregroundStyle(
        isActive
          ? colors.activeForeground
          : colors.inactiveForeground
      )
      .background(
        isActive
          ? colors.activeBackground
          : colors.inactiveBackground
      )
  }
}

extension View {
  func interactiveColors(
    _ isActive: Bool,
    _ colors: InteractiveColors
  ) -> some View {
    modifier(
      InteractiveColorsModifier(
        isActive: isActive,
        colors: colors
      )
    )
  }
}

struct InteractiveButtonStyle: ButtonStyle {
  let colors: InteractiveColors

  init(_ colors: InteractiveColors) {
    self.colors = colors
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundStyle(
        configuration.isPressed
          ? colors.activeForeground
          : colors.inactiveForeground
      )
      .background(
        configuration.isPressed
          ? colors.activeBackground
          : colors.inactiveBackground
      )
  }
}

extension ButtonStyle where Self == InteractiveButtonStyle {
  static func interactiveColors(_ accent: Color) -> Self {
    Self(.init(accent: accent))
  }
}

#Preview {
  @Previewable @State var isDark = false

  VStack {
    HStack(spacing: 24) {
      VStack(spacing: 12) {
        Text("Item")
          .interactiveColors(true, .themeGreen)
        Text("Item")
          .interactiveColors(false, .themeGreen)
        Text("Item")
          .interactiveColors(true, .themeYellow)
        Text("Item")
          .interactiveColors(false, .themeYellow)
      }

      VStack(alignment: .center, spacing: 12) {
        Button("With sound") {}
          .tapSound()
          .buttonStyle(.interactiveColors(.themeGreen))
        Button("With sound") {}
          .tapSound()
          .buttonStyle(.interactiveColors(.themeYellow))
        Button("No sound") {}
          .buttonStyle(.interactiveColors(.themePurple))
      }
    }
    .padding()
    .font(.themeFont(.body))
    .background(.themeBackground)

    Button("Toggle scheme") {
      isDark.toggle()
    }
  }
  .preferredColorScheme(isDark ? .dark : .light)
}
