import SwiftUI

struct DatassetteBottomBarModifier: ViewModifier {
  @Environment(Router.self) private var router
  @Environment(PlaybackService.self) private var playback

  func body(content: Content) -> some View {
    content
      .safeAreaBar(edge: .bottom) {
        Button {
          router.sheetItem = .playback

        } label: {
          HStack {
            Text(playback.currentEpisode?.title ?? "Not playing")
              .frame(
                maxWidth: .infinity,
                alignment: .leading
              )

            Button(
              "Playback",
              systemImage: playback.isPlaying
                ? "pause.fill"
                : "play.fill"
            ) {
              playback.togglePlayPause()
            }
            .labelStyle(.iconOnly)
          }
          .padding()
          .frame(maxWidth: .infinity)
          .font(.themeFont(size: 18).bold())
          .foregroundStyle(.themePrimary)
          .background(.themeSecondary)
        }
      }
  }
}

extension View {
  func withDatassetteBottomBar() -> some View {
    modifier(DatassetteBottomBarModifier())
  }
}

#Preview {
  NavigationStack {
    Text("Hello, world!")
      .frame(maxHeight: .infinity)
      .withDatassetteBottomBar()
  }
  .environment(Router())
  .environment(PlaybackService())
}
