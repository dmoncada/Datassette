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

        VStack(alignment: .center) {
          Text(current?.episodeName ?? "No Title")
            .minimumScaleFactor(0.5)
            .scaledToFit()
        }
        .frame(height: 40)
      }
      .frame(maxWidth: 320, alignment: .leading)
      .font(.themeFont(.title).weight(.light))
      .foregroundStyle(.themePrimary)

      oneSpace
      marqueeRow
      controlRow1
      controlRow2
    }
    .disabled(playback.currentEpisode == nil)
    .foregroundStyle(.themeSecondary)
    .font(.themeFont(.body))
  }
}

extension PlaybackSheet {
  private var current: Episode? {
    playback.currentEpisode
  }

  @ViewBuilder
  private var marqueeRow: some View {
    if let current {
      DatassetteMarquee(current.title, width: width)
        .id(current.title)

    } else {
      oneSpace
    }
  }

  private var controlRow1: some View {
    HStack(spacing: 0) {
      DatassetteButton(.prev) {
        if let prev = episodes.getPrev(for: current) {
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
        if let next = episodes.getNext(for: current) {
          playback.play(next)
        }
      }
    }
    .tint(.themeGreen)
  }

  private var controlRow2: some View {
    HStack(spacing: 0) {
      progressView

      oneSpace

      DatassetteButton(.volumeDown) {
        volume = (volume - 5).clamped(to: 10 ... 100)
        // TODO
      }

      oneSpace

      volumeView

      oneSpace

      DatassetteButton(.volumeUp) {
        volume = (volume + 5).clamped(to: 10 ... 100)
        // TODO
      }

      oneSpace

      DatassetteButton(.random) {
        if let random = episodes.getRandom() {
          playback.play(random)
        }
      }
    }
    .tint(.themePurple)
  }

  private var progressView: some View {
    if current != nil {
      Text(
        Duration.seconds(playback.currentTime),
        format: .time(pattern: .hourMinuteSecond(padHourToLength: 2))
      )

    } else {
      Text("--:--:--")
    }
  }

  private var volumeView: some View {
    if current != nil {
      Text(volume, format: .percent(padPercentageToLength: 3))

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
