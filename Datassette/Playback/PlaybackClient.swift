import MediaPlayer

@preconcurrency typealias TimeObserver = @Sendable (TimeInterval, TimeInterval) -> Void

@MainActor
private final class PlayerBox {
  var player: AVPlayer?
}

@MainActor
struct PlaybackClient {
  var load: (_ url: URL, _ startTime: TimeInterval) -> Void
  var play: () -> Void
  var pause: () -> Void
  var seek: (_ to: TimeInterval) -> Void
  var addTimeObserver: (_ handler: @escaping TimeObserver) -> AnyObject
  var removeObserver: (_ token: AnyObject) -> Void
  var updateNowPlaying:
    (
      _ episode: Episode,
      _ isPlaying: Bool,
      _ current: TimeInterval,
      _ duration: TimeInterval
    ) -> Void
  var tearDown: () -> Void
}

extension PlaybackClient {
  static var live: Self = {
    let box = PlayerBox()

    #if os(iOS)
      let instance = AVAudioSession.sharedInstance()
      try? instance.setCategory(.playback, mode: .default, options: [])
      try? instance.setActive(true)
    #endif

    return Self(
      load: { url, startTime in
        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        box.player = player
        if startTime > 0 {
          player.seek(to: CMTime(seconds: startTime, preferredTimescale: 1000))
        }
      },
      play: {
        box.player?.play()
      },
      pause: {
        box.player?.pause()
      },
      seek: { time in
        box.player?.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
      },
      addTimeObserver: { handler in
        guard let player = box.player else { return NSObject() }
        return player.addPeriodicTimeObserver(
          forInterval: CMTime(seconds: 1, preferredTimescale: 1),
          queue: .main
        ) { [weak player] time in
          guard let player else { return }
          let current = time.seconds
          let rawDuration = player.currentItem?.duration.seconds
          let duration = rawDuration.flatMap { $0.isFinite ? $0 : nil } ?? 0
          handler(current, duration)
        } as AnyObject
      },
      removeObserver: { token in
        box.player?.removeTimeObserver(token)
      },
      updateNowPlaying: { episode, isPlaying, current, duration in
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = episode.title
        info[MPMediaItemPropertyArtist] = "Music for Programming"
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = current
        info[MPMediaItemPropertyPlaybackDuration] = duration
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
      },
      tearDown: {
        box.player?.pause()
        box.player = nil
      }
    )
  }()

  static var mock =
    Self(
      load: { _, _ in },
      play: {},
      pause: {},
      seek: { _ in },
      addTimeObserver: { _ in NSObject() },
      removeObserver: { _ in },
      updateNowPlaying: { _, _, _, _ in },
      tearDown: {}
    )
}
