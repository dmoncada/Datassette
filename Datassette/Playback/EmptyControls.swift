import SwiftUI

struct EmptyControls: View {
  let episodes: EpisodeService
  let playback: PlaybackService

  init(
    _ episodes: EpisodeService,
    _ playback: PlaybackService,
  ) {
    self.episodes = episodes
    self.playback = playback
  }

  var body: some View {
    VStack(spacing: 8) {
      Group {
        Text("No Episode")
        Text("Not Playing")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.themeFont(.title).weight(.light))
      .foregroundStyle(.themePrimary)

      Text(" ")
      Text(" ")

      Text("[----] [---] [----] [---] [----]")
        .foregroundStyle(.themeSecondary)

      HStack(spacing: 0) {
        Text("--:--:-- [--] .... [--] ")
          .foregroundStyle(.themeSecondary)

        Button("[random]") {
          if let random = episodes.getRandom() {
            playback.play(random)
          }
        }
        .buttonStyle(.datassetteButton)
        .tint(.themePurple)
        .tapSound()
      }
    }
  }
}
