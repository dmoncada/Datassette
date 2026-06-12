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
