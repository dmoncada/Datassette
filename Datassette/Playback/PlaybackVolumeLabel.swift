import SwiftUI

struct PlaybackVolumeLabel: View {
  @Environment(PlaybackService.self) private var playback

  let volume: Int

  var body: some View {
    if playback.currentEpisode != nil {
      Text(volume, format: .percent(padPercentageToLength: 3))

    } else {
      Text("....")
    }
  }
}
