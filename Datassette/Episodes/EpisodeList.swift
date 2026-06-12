import SwiftUI

struct DatassetteEpisodes: View {
  @Environment(EpisodeService.self) private var episodes

  var body: some View {
    Group {
      switch episodes.state {
      case .loading:
        ProgressView()

      case .failure(_):
        ContentUnavailableView.search

      case .success:
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(episodes.episodes) { episode in
              EpisodeRow(episode)
            }
          }
        }
        .scrollIndicators(.hidden)
      }
    }
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity
    )
    .task {
      await episodes.loadEpisodes()
    }
  }
}

#Preview("Loading") {
  DatassetteEpisodes()
    .environment(EpisodeService(feedClient: .mock))
    .environment(PlaybackService())
}

#Preview("Error") {
  DatassetteEpisodes()
    .environment(EpisodeService(feedClient: .failing))
    .environment(PlaybackService())
}
