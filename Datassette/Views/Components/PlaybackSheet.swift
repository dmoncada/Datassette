import SwiftUI

struct PlaybackSheet: View {
  @Environment(PlaybackService.self) private var playback

  private let width = 32

  var body: some View {
    Group {
      if let episode = playback.currentEpisode {
        PlaybackControls(episode: episode, playback: playback, width: width)

      } else {
        EmptyControls(width: width)
      }
    }
    .font(.themeFont(size: 16))
  }
}

private struct PlaybackControls: View {
  let episode: Episode
  let playback: PlaybackService
  let width: Int

  @State private var volume = 100

  var body: some View {
    VStack(spacing: 8) {
      DatassetteMarquee(episode.title, width: width)
        .foregroundStyle(.themeSecondary)

      HStack(spacing: 0) {
        Button("[prev]") {
          // TODO
        }

        Text(" ")

        Button("[-30]") {
          playback.seek(to: playback.currentTime - 30)
        }

        Text(" ")

        Button("[\(playback.isPlaying ? "stop" : "play")]") {
          playback.togglePlayPause()
        }

        Text(" ")

        Button("[+30]") {
          playback.seek(to: playback.currentTime + 30)
        }

        Text(" ")

        Button("[next]") {
          // TODO
        }
      }
      .foregroundStyle(.themeGreen)

      HStack(spacing: 0) {
        Text(
          Duration.seconds(playback.currentTime),
          format: .time(pattern: .hourMinuteSecond(padHourToLength: 2))
        )
        .foregroundStyle(.themeSecondary)

        Text(" ")

        Button("[v-]") {
          volume = (volume - 5).clamped(to: 0...100)
          // TODO
        }
        .foregroundStyle(.themePurple)

        Text(" ")

        Text(String(format: "%-3d%%", volume))
          .foregroundStyle(.themeSecondary)

        Text(" ")

        Button("[v+]") {
          volume = (volume + 5).clamped(to: 0...100)
          // TODO
        }
        .foregroundStyle(.themePurple)

        Text(" ")

        Button("[random]") {
          // TODO
        }
        .foregroundStyle(.themePurple)
      }
    }
  }
}

private struct EmptyControls: View {
  let width: Int

  var body: some View {
    VStack(spacing: 8) {
      Text(String(repeating: " ", count: width))

      Text("[----] [---] [----] [---] [----]")
        .foregroundStyle(.themeSecondary)

      HStack(spacing: 0) {
        Text("--:--:-- [--] .... [--] ")
          .foregroundStyle(.themeSecondary)

        Button("[random]") {
          // TODO
        }
        .foregroundStyle(.themePurple)
      }
    }
  }
}

#Preview("Playback") {
  @Previewable @State var playback = PlaybackService()
  @Previewable @State var isPresented = false

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

  VStack {
    Button("Show sheet") {
      isPresented = true
    }
  }
  .sheet(isPresented: $isPresented) {
    PlaybackSheet()
      .presentationDetents([.medium])
  }
  .onAppear {
    playback.play(episode)
    playback.togglePlayPause()
    playback.seek(to: 0)
  }
  .environment(playback)
}

#Preview("Empty") {
  @Previewable @State var playback = PlaybackService()
  @Previewable @State var isPresented = false

  VStack {
    Button("Show sheet") {
      isPresented = true
    }
  }
  .sheet(isPresented: $isPresented) {
    PlaybackSheet()
      .presentationDetents([.medium])
  }
  .environment(playback)
}
