import SwiftUI

struct DatassetteButton: View {
  @Environment(\.isEnabled) var isEnabled

  private let label: String
  private let action: () -> Void

  init(
    _ label: ControlLabels,
    action: @escaping () -> Void
  ) {
    self.init(label.rawValue, action: action)
  }

  init(
    _ label: String,
    action: @escaping () -> Void
  ) {
    self.label = label
    self.action = action
  }

  var resolvedLabel: String {
    isEnabled
      ? "[\(label)]"
      : "[\(String(label.map { _ in "-" }))]"
  }

  var body: some View {
    Button(resolvedLabel, action: action)
      .buttonStyle(.datassetteButton)
      .tapSound()
  }
}

#Preview {
  VStack(spacing: 12) {
    DatassetteButton(.prev) {}
      .tint(.themeGreen)
    DatassetteButton(.play) {}
      .tint(.themeYellow)
    DatassetteButton(.next) {}
      .disabled(true)
  }
  .padding()
  .font(.themeFont(.body))
  .background(.themeBackground)
}
