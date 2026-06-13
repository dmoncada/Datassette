import SwiftUI

struct DatassetteBottomBarModifier: ViewModifier {
  @Environment(Router.self) private var router
  @Environment(EpisodeService.self) private var episodes
  @Environment(PlaybackService.self) private var playback

  func body(content: Content) -> some View {
    content
      .safeAreaBar(edge: .bottom) {
        Button {
          router.sheetItem = .playback

        } label: {
          let current = playback.currentEpisode

          HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
              if let current {
                VStack(alignment: .center) {
                  Text(current.episodeName)
                    .minimumScaleFactor(0.5)
                    .scaledToFit()
                }
                .frame(height: 32)

                Text(current.episodeNumber)
                  .font(.themeFont(.subheadline))

              } else {
                Text("Not Playing")
              }
            }
            .frame(height: 60)
            .frame(
              maxWidth: .infinity,
              alignment: .leading
            )

            Button(
              "Playback",
              systemImage:
                playback.isPlaying
                ? "pause.fill"
                : "play.fill"
            ) {
              playback.togglePlayPause()
            }

            Button("Fast Forward", systemImage: "forward.fill") {
              if let current, let next = episodes.getNext(for: current) {
                playback.play(next)
              }
            }
          }
          .padding()
          .font(.themeFont(.title3).bold())
          .foregroundStyle(.themePrimary)
          .background(.themeSecondary)
          .labelStyle(.iconOnly)
        }
      }
  }
}

extension View {
  func withDatassetteBottomBar() -> some View {
    modifier(DatassetteBottomBarModifier())
  }
}

#Preview(traits: .modifier(MockData(.loadAndSet))) {
  @Previewable @Environment(EpisodeService.self) var episodes
  @Previewable @Environment(PlaybackService.self) var playback

  @Previewable @State var load = false

  NavigationStack {
    Button("Toggle view") {
      if load {
        playback.play(episodes.episodes[0])

      } else {
        playback.currentEpisode = nil
      }

      load.toggle()
    }
    .frame(maxHeight: .infinity)
    .withDatassetteBottomBar()
  }
  .environment(Router())
}
