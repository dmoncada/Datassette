import SwiftUI

struct PlaybackSheet: View {
  @Environment(PlaybackService.self) private var playback

  private let width = 32

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Group {
        Text(playback.currentEpisode?.episodeNumber ?? "No Episode")

        VStack(alignment: .center) {
          Text(playback.currentEpisode?.episodeName ?? "No Title")
            .minimumScaleFactor(0.5)
            .scaledToFit()
        }
        .frame(height: 40)
      }
      .frame(maxWidth: 320, alignment: .leading)
      .font(.themeFont(.title).weight(.light))
      .foregroundStyle(.themePrimary)

      Text(" ")

      PlaybackMarqueeRow(width: width)
      PlaybackTransportRow()
      PlaybackSecondaryRow()
    }
    .disabled(playback.currentEpisode == nil)
    .foregroundStyle(.themeSecondary)
    .font(.themeFont(.body))
  }
}

#Preview(traits: .modifier(MockData(.loadAndSet))) {
  @Previewable @Environment(EpisodeService.self) var episodes
  @Previewable @Environment(PlaybackService.self) var playback

  @Previewable @State var load = false

  VStack {
    PlaybackSheet()
      .padding()
      .background(.themeBackground)

    Button("Toggle view") {
      if load {
        playback.play(episodes.episodes[0])

      } else {
        playback.currentEpisode = nil
      }

      load.toggle()
    }
  }
}
