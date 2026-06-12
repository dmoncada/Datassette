import SwiftUI

struct DatassetteStyleModifier: ViewModifier {
  @Environment(\.isEnabled) var isEnabled

  let isActive: Bool

  private var isDisabled: Bool { isEnabled == false }

  func body(content: Content) -> some View {
    content
      .foregroundStyle(
        isDisabled
          ? AnyShapeStyle(.themeSecondary)
          : isActive
            ? AnyShapeStyle(.themeBlack)
            : AnyShapeStyle(.tint)
      )
      .background(
        isActive
          ? AnyShapeStyle(.tint)
          : AnyShapeStyle(.clear)
      )
  }
}

struct DatassetteButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .datassetteStyle(configuration.isPressed)
  }
}

extension View {
  func datassetteStyle(_ isActive: Bool) -> some View {
    modifier(DatassetteStyleModifier(isActive: isActive))
  }
}

extension ButtonStyle where Self == DatassetteButtonStyle {
  static var datassetteButton: Self { .init() }
}

#Preview {
  @Previewable @State var isDark = false

  VStack {
    HStack(spacing: 24) {
      VStack(spacing: 12) {
        Group {
          Text("Item")
            .datassetteStyle(true)
          Text("Item")
            .datassetteStyle(false)
        }
        .tint(.themeGreen)

        Group {
          Text("Item")
            .datassetteStyle(true)
          Text("Item")
            .datassetteStyle(false)
        }
        .tint(.themeYellow)
      }

      VStack(alignment: .center, spacing: 12) {
        Button("With sound") {}
          .tapSound()
          .tint(.themeGreen)
        Button("No sound") {}
          .tint(.themeYellow)
        Button("Disabled") {}
          .tint(.themePurple)
          .disabled(true)
      }
    }
    .padding()
    .font(.themeFont(.body))
    .background(.themeBackground)
    .buttonStyle(.datassetteButton)

    Button("Toggle scheme") {
      isDark.toggle()
    }
  }
  .preferredColorScheme(isDark ? .dark : .light)
}
