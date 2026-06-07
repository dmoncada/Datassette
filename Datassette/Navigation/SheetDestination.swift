import SwiftUI

enum SheetDestination: Identifiable, Hashable {
  case settings
  case playback

  var id: String {
    switch self {
    case .settings: "settings"
    case .playback: "playback"
    }
  }
}

extension View {
  func withSheetDestination(
    _ item: Binding<SheetDestination?>
  ) -> some View {
    sheet(item: item) { destination in
      switch destination {
      case .settings:
        SettingsSheet()
          .presentationDetents([.medium])

      case .playback:
        PlaybackSheet()
          .presentationDetents([.medium])
      }
    }
  }
}
