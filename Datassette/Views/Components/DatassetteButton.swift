import SwiftUI

struct DatassetteButton: View {
  @Environment(\.isEnabled) var isEnabled

  private let label: String
  private let action: () -> Void

  init(
    _ label: ControlLabels,
    action: @escaping () -> Void
  ) {
    self.label = label.rawValue
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
