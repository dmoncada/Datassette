import Foundation
import MediaPlayer
import os

extension Logger.Datassette.Category {
  fileprivate static let playbackService = Self(rawValue: "playbackService")
}

@MainActor
@Observable
final class PlaybackService {
  // MARK: - State
  var currentEpisode: Episode?
  var isPlaying: Bool = false
  var currentTime: TimeInterval = 0
  var duration: TimeInterval = 0

  private let client: PlaybackClient
  //  private let persistence: PersistenceClient
  //  private let downloads: DownloadClient
  private let logger = Logger(category: .playbackService)
  private var timeObserverToken: AnyObject?
  //  private var saveTimer: Timer?

  //  init(
  //    client: PlaybackClient = .live,
  //    persistence: PersistenceClient = .live,
  //    downloads: DownloadClient = .live
  //  ) {
  //    self.client = client
  //    self.persistence = persistence
  //    self.downloads = downloads
  //    setupRemoteCommands()
  //  }

  init(client: PlaybackClient? = nil) {
    self.client = client ?? .live
    setupRemoteCommands()
  }

  // MARK: - Public API

  func play(_ episode: Episode) {
    //    if currentEpisode?.id == episode.id {
    //      if !isPlaying { togglePlayPause() }
    //      return
    //    }

    // Remove observer from old player before loading new episode
    if let token = timeObserverToken {
      client.removeObserver(token)
      timeObserverToken = nil
    }

    currentEpisode = episode

    //    let savedPosition = persistence.getPosition(episode.id)
    //    let url = downloads.isDownloaded(episode)
    //      ? downloads.localURL(episode)
    //      : episode.enclosureURL

    let savedPosition: Double = 0
    let url = episode.enclosureURL

    client.load(url, savedPosition)

    timeObserverToken = client.addTimeObserver { [weak self] current, duration in
      guard let self else { return }
      self.currentTime = current
      self.duration = duration
      self.client.updateNowPlaying(episode, self.isPlaying, current, duration)
    }

    client.play()
    isPlaying = true

    client.updateNowPlaying(episode, true, savedPosition, 0)
    //    startPositionSaveTimer()
  }

  func togglePlayPause() {
    guard let episode = currentEpisode else { return }
    if isPlaying {
      client.pause()
    } else {
      client.play()
    }
    isPlaying.toggle()
    client.updateNowPlaying(episode, isPlaying, currentTime, duration)
  }

  func seek(to time: TimeInterval) {
    guard let _ = currentEpisode else { return }
    let target = time.clamped(to: 0...duration)
    client.seek(target)
  }

  // MARK: - Private

  private func setupRemoteCommands() {
    let commandCenter = MPRemoteCommandCenter.shared()

    commandCenter.playCommand.addTarget { [weak self] _ in
      MainActor.assumeIsolated {
        self?.isPlaying = true
        self?.client.play()
      }
      return .success
    }

    commandCenter.pauseCommand.addTarget { [weak self] _ in
      MainActor.assumeIsolated {
        self?.isPlaying = false
        self?.client.pause()
      }
      return .success
    }

    commandCenter.nextTrackCommand.addTarget { _ in .commandFailed }
    commandCenter.previousTrackCommand.addTarget { _ in .commandFailed }
  }

  //  private func startPositionSaveTimer() {
  //    saveTimer?.invalidate()
  //    saveTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
  //      MainActor.assumeIsolated {
  //        guard let self, let episode = self.currentEpisode else { return }
  //        self.persistence.savePosition(episode.id, self.currentTime)
  //      }
  //    }
  //  }

  isolated deinit {
    if let timeObserverToken {
      client.removeObserver(timeObserverToken)
    }
    //    saveTimer?.invalidate()
    client.tearDown()
  }
}

extension Comparable {
  func clamped(to range: ClosedRange<Self>) -> Self {
    min(max(self, range.lowerBound), range.upperBound)
  }
}
