import SwiftUI

struct MockData: PreviewModifier {
  enum InitAction {
    case load
    case loadAndSet
  }

  let initAction: InitAction?

  init(_ initAction: InitAction? = nil) {
    self.initAction = initAction
  }

  @State private var episodes = EpisodeService(feedClient: .mock)
  @State private var playback = PlaybackService(client: .mock)

  func body(content: Content, context: Void) -> some View {
    content
      .task {
        switch initAction {
        case .load:
          await episodes.loadEpisodes()

        case .loadAndSet:
          await episodes.loadEpisodes()
          playback.play(episodes.episodes[0])
          playback.togglePlayPause()
          playback.seek(to: .zero)

        default:
          break
        }
      }
      .environment(episodes)
      .environment(playback)
  }
}
