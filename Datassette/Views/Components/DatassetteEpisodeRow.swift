import SwiftUI

struct EpisodeRow: View {
  let episode: Episode

  //  @Environment(DownloadService.self) private var download
  @Environment(PlaybackService.self) private var playback

  @State private var isPopoverPresented = false

  private let options: [PopoverModel] = [
    .favorite("star"),
    .download("arrow.down.circle"),
  ]

  var body: some View {
    Button {
      playback.play(episode)

    } label: {
      HStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 4) {
          Text(episode.title.removingPrefix("Episode "))
            .foregroundStyle(
              playback.currentEpisode == episode
                ? .themePurple
                : .themeGreen
            )
            .font(.themeFont(size: 16).bold().italic())
            .lineLimit(1)

          HStack(spacing: 4) {
            Text(episode.publicationDate, style: .date)

            if let duration = episode.duration {
              Text("•")
              Text(
                Duration.seconds(duration),
                format: .time(pattern: .hourMinuteSecond)
              )
            }
          }
          .foregroundStyle(.themeSecondary)
          .font(.themeFont(size: 12))
        }
        .frame(
          maxWidth: .infinity,
          alignment: .leading
        )

        // DownloadStateIndicator(state: download.state(for: episode))

        Button("Options", systemImage: "ellipsis") {
          isPopoverPresented = true
        }
        .padding(.leading)
        .labelStyle(.iconOnly)
        .foregroundStyle(.themeSecondary)
        .popover(isPresented: $isPopoverPresented) {
          popover(options)
            .presentationCompactAdaptation(.popover)
        }
      }
    }
    .padding(.vertical)
    .frame(maxWidth: .infinity)
  }

  private func popover(_ options: [PopoverModel]) -> some View {
    VStack {
      ForEach(options) { option in
        Button(option.kind.description.capitalized, systemImage: option.icon) {
          defer { isPopoverPresented = false }
          handle(option.kind)
        }
        .foregroundStyle(.themeSecondary)
        .font(.themeFont(size: 12).bold())
        .buttonStyle(.glass)
      }
    }
    .padding()
  }

  private func handle(_ kind: ActionKind) {
    switch kind {
    case .favorite: break
    case .download: break
    //      download.toggle(episode)
    }
  }
}

extension String {
  func removingPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

extension EpisodeRow {
  enum ActionKind: String {
    case favorite
    case download
  }

  struct PopoverModel: Identifiable {
    let id = UUID()
    let kind: ActionKind
    let icon: String
  }
}

extension EpisodeRow.ActionKind: CustomStringConvertible {
  var description: String {
    rawValue
  }
}

extension EpisodeRow.PopoverModel {
  static func favorite(_ icon: String) -> Self {
    .init(kind: .favorite, icon: icon)
  }
  static func download(_ icon: String) -> Self {
    .init(kind: .download, icon: icon)
  }
}

#Preview {
  let episode = Episode(
    id: "78",
    title: "Episode 78: Datassette",
    publicationDate: Date(),
    enclosureURL: .init(
      string: "https://datashat.net/music_for_programming_78-datassette.mp3"
    )!,
    duration: 5400,
    description: nil
  )

  EpisodeRow(episode: episode)
    .environment(PlaybackService())
    .background(.themeBackground)
    .padding(.horizontal)
}
