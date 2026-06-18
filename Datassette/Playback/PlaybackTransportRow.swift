import SwiftUI

struct PlaybackTransportRow: View {
  @Environment(EpisodeService.self) private var episodes
  @Environment(PlaybackService.self) private var playback

  var body: some View {
    HStack(spacing: 0) {
      DatassetteButton(.prev) {
        if let prev = episodes.getPrev(for: playback.currentEpisode) {
          playback.play(prev)
        }
      }

      oneSpace

      DatassetteButton(.back) {
        playback.seek(to: playback.currentTime - 30)
      }

      oneSpace

      DatassetteButton(playback.isPlaying ? .stop : .play) {
        playback.togglePlayPause()
      }

      oneSpace

      DatassetteButton(.forward) {
        playback.seek(to: playback.currentTime + 30)
      }

      oneSpace

      DatassetteButton(.next) {
        if let next = episodes.getNext(for: playback.currentEpisode) {
          playback.play(next)
        }
      }
    }
    .tint(.themeGreen)
  }

  private var oneSpace: some View {
    Text(" ")
  }
}
