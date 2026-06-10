import SwiftUI

struct PlaybackSheet: View {
  @Environment(EpisodeService.self) private var episodes
  @Environment(PlaybackService.self) private var playback

  private let width = 32

  var body: some View {
    Group {
      if let episode = playback.currentEpisode {
        PlaybackControls(episode, episodes, playback, width: width)

      } else {
        EmptyControls(episodes, playback, width: width)
      }
    }
    .font(.themeFont(.body))
    .padding()
  }
}

private struct PlaybackControls: View {
  let current: Episode
  let episodes: EpisodeService
  let playback: PlaybackService
  let width: Int

  init(
    _ current: Episode,
    _ episodes: EpisodeService,
    _ playback: PlaybackService,
    width: Int,
  ) {
    self.current = current
    self.episodes = episodes
    self.playback = playback
    self.width = width
  }

  @State private var volume = 100

  var body: some View {
    VStack(spacing: 8) {
      ForEach(current.title.breakLine(after: ":"), id: \.self) { line in
        Text(line)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.themeFont(.title).weight(.light))
      .foregroundStyle(.themePrimary)
      .truncationMode(.tail)
      .lineLimit(1)

      oneLine()

      DatassetteMarquee(current.title, width: width)
        .foregroundStyle(.themeSecondary)
        .id(current.title)

      HStack(spacing: 0) {
        Button("[prev]") {
          if let prev = episodes.getPrev(for: current) {
            playback.play(prev)
          }
        }
        .tapSound()

        oneSpace()

        Button("[-30]") {
          playback.seek(to: playback.currentTime - 30)
        }
        .tapSound()

        oneSpace()

        Button("[\(playback.isPlaying ? "stop" : "play")]") {
          playback.togglePlayPause()
        }
        .tapSound()

        oneSpace()

        Button("[+30]") {
          playback.seek(to: playback.currentTime + 30)
        }
        .tapSound()

        oneSpace()

        Button("[next]") {
          if let next = episodes.getNext(for: current) {
            playback.play(next)
          }
        }
        .tapSound()
      }
      .buttonStyle(.interactiveColors(.themeGreen))

      HStack(spacing: 0) {
        Text(
          Duration.seconds(playback.currentTime),
          format: .time(pattern: .hourMinuteSecond(padHourToLength: 2))
        )
        .foregroundStyle(.themeSecondary)

        oneSpace()

        Button("[v-]") {
          volume = (volume - 5).clamped(to: 0 ... 100)
          // TODO
        }
        .tapSound()
        .buttonStyle(.interactiveColors(.themePurple))

        oneSpace()

        Text(volume, format: .percent.precision(.integerLength(3)))
          .foregroundStyle(.themeSecondary)

        oneSpace()

        Button("[v+]") {
          volume = (volume + 5).clamped(to: 0 ... 100)
          // TODO
        }
        .tapSound()
        .buttonStyle(.interactiveColors(.themePurple))

        oneSpace()

        Button("[random]") {
          if let random = episodes.getRandom() {
            playback.play(random)
          }
        }
        .tapSound()
        .buttonStyle(.interactiveColors(.themePurple))
      }
    }
  }
}

private struct EmptyControls: View {
  let episodes: EpisodeService
  let playback: PlaybackService
  let width: Int

  init(
    _ episodes: EpisodeService,
    _ playback: PlaybackService,
    width: Int
  ) {
    self.episodes = episodes
    self.playback = playback
    self.width = width
  }

  var body: some View {
    VStack(spacing: 8) {
      Group {
        Text("No Episode")
        Text("Not Playing")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.themeFont(.title).weight(.light))
      .foregroundStyle(.themePrimary)

      oneLine()
      oneLine()

      Text("[----] [---] [----] [---] [----]")
        .foregroundStyle(.themeSecondary)

      HStack(spacing: 0) {
        Text("--:--:-- [--] .... [--] ")
          .foregroundStyle(.themeSecondary)

        Button("[random]") {
          if let random = episodes.getRandom() {
            playback.play(random)
          }
        }
        .tapSound()
        .buttonStyle(.interactiveColors(.themePurple))
      }
    }
  }
}

@ViewBuilder
private func oneLine() -> some View { Text(" ").frame(maxWidth: .infinity) }
@ViewBuilder
private func oneSpace() -> some View { Text(" ") }

extension String {
  fileprivate func breakLine(after separator: String) -> [String] {
    guard let range = self.range(of: separator)
    else { return [self] }

    return [
      String(self[..<range.upperBound]),
      String(self[range.upperBound...]).trimmingCharacters(in: .whitespaces),
    ]
  }
}

private struct Preview: View {
  @State private var isPresented = false

  var body: some View {
    Button("Show sheet") {
      isPresented = true
    }
    .sheet(isPresented: $isPresented) {
      PlaybackSheet()
        .presentationDetents([.medium, .large])
    }
  }
}

#Preview("Playback") {
  @Previewable @State var episodes = EpisodeService(feedClient: .mock)
  @Previewable @State var playback = PlaybackService(client: .mock)

  Preview()
    .task {
      await episodes.loadEpisodes()
      playback.play(episodes.episodes[0])
      playback.togglePlayPause()
      playback.seek(to: 0)
    }
    .environment(episodes)
    .environment(playback)
}

#Preview("Empty") {
  @Previewable @State var episodes = EpisodeService(feedClient: .mock)
  @Previewable @State var playback = PlaybackService(client: .mock)

  Preview()
    .environment(episodes)
    .environment(playback)
}

#Preview("Both") {
  @Previewable @State var episodes = EpisodeService(feedClient: .mock)
  @Previewable @State var playback = PlaybackService(client: .mock)

  @Previewable @State var isActive = true
  @Previewable @State var isDark = false

  let width = 32

  VStack {
    Group {
      if isActive, let episode = playback.currentEpisode {
        PlaybackControls(episode, episodes, playback, width: width)

      } else {
        EmptyControls(episodes, playback, width: width)
      }
    }
    .padding()
    .font(.themeFont(.body))
    .background(.themeBackground)

    HStack(spacing: 24) {
      Button("Toggle view") {
        isActive.toggle()
      }

      Button("Toggle scheme") {
        isDark.toggle()
      }
    }
  }
  .preferredColorScheme(isDark ? .dark : .light)
  .task {
    await episodes.loadEpisodes()
    playback.play(episodes.episodes[0])
    playback.togglePlayPause()
    playback.seek(to: 0)
  }
}
