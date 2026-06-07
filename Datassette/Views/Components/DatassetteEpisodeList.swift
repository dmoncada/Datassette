import SwiftUI

struct DatassetteEpisodes: View {
  @Environment(AppViewModel.self) private var vm

  var body: some View {
    Group {
      switch vm.state {
      case .loading:
        ProgressView()

      case .failure(_):
        ContentUnavailableView.search

      case .success:
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(vm.episodes) { episode in
              EpisodeRow(episode: episode)
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
      await vm.loadEpisodes()
    }
  }
}

#Preview("Loading") {
  DatassetteEpisodes()
    .environment(AppViewModel(feedClient: .mock))
    .environment(PlaybackService())
}

#Preview("Error") {
  DatassetteEpisodes()
    .environment(AppViewModel(feedClient: .failing))
    .environment(PlaybackService())
}
