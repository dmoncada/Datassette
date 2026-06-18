import SwiftUI

struct PlaybackMarqueeRow: View {
  @Environment(PlaybackService.self) private var playback

  let width: Int

  var body: some View {
    if let episode = playback.currentEpisode {
      DatassetteMarquee(episode.title, width: width)
        .id(episode.title)

    } else {
      Text(" ")
    }
  }
}
