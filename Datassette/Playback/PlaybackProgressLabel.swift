import SwiftUI

struct PlaybackProgressLabel: View {
  @Environment(PlaybackService.self) private var playback

  var body: some View {
    if playback.currentEpisode != nil {
      Text(
        Duration.seconds(playback.currentTime),
        format: .time(pattern: .hourMinuteSecond(padHourToLength: 2))
      )

    } else {
      Text("--:--:--")
    }
  }
}
