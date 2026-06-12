import SwiftUI

struct DatassetteAppShell: View {
  @AppStorage(.storageKeys.colorScheme)
  private var preference: ColorSchemePreference = .system

  @State private var router = Router()
  @State private var episodes = EpisodeService()
  @State private var playback = PlaybackService()

  var body: some View {
    NavigationStack {
      DatassetteEpisodes()
        .padding(.horizontal)
        .withDatassetteTopBar()
        .withDatassetteBottomBar()
        .background(.themeBackground)
    }
    .withSheetDestination($router.sheetItem)
    .preferredColorScheme(preference.colorScheme)
    .onAppear { try? AudioService.shared.preloadSounds() }
    .environment(router)
    .environment(episodes)
    .environment(playback)
  }
}

#Preview {
  DatassetteAppShell()
}
