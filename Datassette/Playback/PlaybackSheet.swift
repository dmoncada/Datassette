import SwiftUI

struct PlaybackSheet: View {
  @Environment(EpisodeService.self) private var episodes
  @Environment(PlaybackService.self) private var playback

  @State private var volume = 100

  private let width = 32

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Group {
        Text(current?.episodeNumber ?? "No Episode")
        Text(current?.episodeName ?? "No Title")
      }
      .font(.themeFont(.title).weight(.light))
      .foregroundStyle(.themePrimary)
      .truncationMode(.tail)
      .lineLimit(1)

      oneSpace

      marqueeView

      HStack(spacing: 0) {
        DatassetteButton(.prev) {
          if let prev = episodes.getPrev(for: playback.currentEpisode) {
            playback.play(prev)
          }
        }

        oneSpace

        DatassetteButton(.back) {
          playback.seek(to: playback.currentTime - 30)
        }

        oneSpace

        DatassetteButton(playback.isPlaying ? .stop : .play) {
          playback.togglePlayPause()
        }

        oneSpace

        DatassetteButton(.forward) {
          playback.seek(to: playback.currentTime + 30)
        }

        oneSpace

        DatassetteButton(.next) {
          if let next = episodes.getNext(for: playback.currentEpisode) {
            playback.play(next)
          }
        }
      }
      .tint(.themeGreen)

      HStack(spacing: 0) {
        progressView
          .foregroundStyle(.themeSecondary)

        oneSpace

        DatassetteButton(.volumeDown) {
          volume = (volume - 5).clamped(to: 10 ... 100)
          // TODO
        }
        .tint(.themePurple)

        oneSpace

        volumeView
          .foregroundStyle(.themeSecondary)

        oneSpace

        DatassetteButton(.volumeUp) {
          volume = (volume + 5).clamped(to: 10 ... 100)
          // TODO
        }
        .tint(.themePurple)

        oneSpace

        DatassetteButton(.random) {
          if let random = episodes.getRandom() {
            playback.play(random)
          }
        }
        .tint(.themePurple)
      }
    }
    .disabled(playback.currentEpisode == nil)
    .font(.themeFont(.body))
  }

  private var current: Episode? {
    playback.currentEpisode
  }

  @ViewBuilder
  private var marqueeView: some View {
    if let title = current?.title {
      DatassetteMarquee(title, width: width)
        .foregroundStyle(.themeSecondary)
        .id(title)

    } else {
      oneSpace
    }
  }

  private var progressView: some View {
    if let current {
      Text(
        Duration.seconds(playback.currentTime),
        format: .time(pattern: .hourMinuteSecond(padHourToLength: 2))
      )

    } else {
      Text("--:--:--")
    }
  }

  private var volumeView: some View {
    if let current {
      Text(volume, format: .paddedPercent(length: 3))

    } else {
      Text("....")
    }
  }

  private var oneSpace: some View {
    Text(" ")
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
