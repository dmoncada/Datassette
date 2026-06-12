import SwiftUI

struct EpisodeRow: View {
  let episode: Episode

  init(_ episode: Episode) {
    self.episode = episode
  }

  @Environment(EpisodeService.self) private var episodes
  @Environment(PlaybackService.self) private var playback

  var body: some View {
    Button {
      playback.play(episode)

    } label: {
      HStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 4) {
          let isFavorite = episodes.isFavorite(episode)
          let isPlaying = playback.isCurrent(episode)

          Text(episode.title.removingPrefix("Episode "))
            .datassetteStyle(isPlaying)
            .tint(isFavorite ? .themeYellow : .themeGreen)
            .font(.themeFont(.headline).bold().italic())
            .lineLimit(1)

          HStack {
            Text(episode.publicationDate, style: .date)

            if let duration = episode.duration {
              Text("•")
              Text(duration, format: .time(pattern: .hourMinuteSecond))
            }
          }
          .foregroundStyle(.themeSecondary)
          .font(.themeFont(.subheadline))
        }
        .frame(
          maxWidth: .infinity,
          alignment: .leading
        )

        // DownloadStateIndicator(state: download.state(for: episode))

        popover
      }
    }
    .padding(.vertical)
    .frame(maxWidth: .infinity)
  }

  private var popover: some View {
    Menu {
      let isFavorite = episodes.isFavorite(episode)
      let label = isFavorite ? "Forget" : "Favorite"
      let image = isFavorite ? "star.fill" : "star"

      Button(label, systemImage: image) {
        episodes.toggleFavorite(episode)
      }

      Button("Download", systemImage: "arrow.down.circle") {}
        .disabled(true)

    } label: {
      Image(systemName: "ellipsis")
        .padding(.leading)
        .padding(.vertical)
        .foregroundStyle(.themeSecondary)
    }
    .menuStyle(.borderlessButton)
    .menuOrder(.fixed)
  }
}

#Preview(traits: .modifier(MockData(.load))) {
  @Previewable @Environment(EpisodeService.self) var episodes

  Group {
    switch episodes.state {
    case .success:
      EpisodeRow(episodes.episodes[0])
        .background(.themeBackground)
        .padding(.horizontal)

    default:
      ProgressView()
    }
  }
}
