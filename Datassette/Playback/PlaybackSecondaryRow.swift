import SwiftUI

struct PlaybackSecondaryRow: View {
  @Environment(EpisodeService.self) private var episodes
  @Environment(PlaybackService.self) private var playback

  @State private var volume = 100

  var body: some View {
    HStack(spacing: 0) {
      PlaybackProgressLabel()

      oneSpace

      DatassetteButton(.volumeDown) {
        volume = (volume - 5).clamped(to: 10 ... 100)
        // TODO
      }

      oneSpace

      PlaybackVolumeLabel(volume: volume)

      oneSpace

      DatassetteButton(.volumeUp) {
        volume = (volume + 5).clamped(to: 10 ... 100)
        // TODO
      }

      oneSpace

      DatassetteButton(.random) {
        if let random = episodes.getRandom() {
          playback.play(random)
        }
      }
    }
    .tint(.themePurple)
  }

  private var oneSpace: some View {
    Text(" ")
  }
}
