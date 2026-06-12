import SwiftUI

/*
struct PlaybackControls: View {
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

      oneSpace()

      DatassetteMarquee(current.title, width: width)
        .foregroundStyle(.themeSecondary)
        .id(current.title)

      HStack(spacing: 0) {
        control(ControlLabels.prev) {
          if let prev = episodes.getPrev(for: current) {
            playback.play(prev)
          }
        }

        oneSpace()

        control(ControlLabels.back) {
          playback.seek(to: playback.currentTime - 30)
        }

        oneSpace()

        control(playback.isPlaying ? ControlLabels.stop : ControlLabels.play) {
          playback.togglePlayPause()
        }

        oneSpace()

        control(ControlLabels.forward) {
          playback.seek(to: playback.currentTime + 30)
        }

        oneSpace()

        control(ControlLabels.next) {
          if let next = episodes.getNext(for: current) {
            playback.play(next)
          }
        }
      }
      .buttonStyle(.datassetteButton)
      .tint(.themeGreen)

      HStack(spacing: 0) {
        Text(
          Duration.seconds(playback.currentTime),
          format: .time(pattern: .hourMinuteSecond(padHourToLength: 2))
        )
        .foregroundStyle(.themeSecondary)

        oneSpace()

        control(ControlLabels.volumeDown) {
          volume = (volume - 5).clamped(to: 10 ... 100)
          // TODO
        }
        .tint(.themePurple)

        oneSpace()

        Text(volume, format: .paddedPercent(length: 3))
          .foregroundStyle(.themeSecondary)

        oneSpace()

        control(ControlLabels.volumeUp) {
          volume = (volume + 5).clamped(to: 10 ... 100)
          // TODO
        }
        .tint(.themePurple)

        oneSpace()

        control(ControlLabels.random) {
          if let random = episodes.getRandom() {
            playback.play(random)
          }
        }
        .tint(.themePurple)
      }
      .buttonStyle(.datassetteButton)
    }
  }

  private func control(
    _ label: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(label, action: action)
      .tapSound()
  }

  private func oneSpace() -> some View { Text(" ") }
}
 */
