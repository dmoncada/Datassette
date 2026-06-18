import AudioToolbox
import SwiftUI

@MainActor
final class AudioService {
  static let shared = AudioService()

  private var soundIds: [Sound: SystemSoundID] = [:]

  private init() {
    try? preloadSounds()
  }

  func preloadSounds() throws {
    for sound in Sound.allCases {
      try preload(sound)
    }
  }

  private func preload(_ sound: Sound) throws {
    guard soundIds[sound] == nil else { return }

    guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav")
    else { throw Error.fileNotFound(sound) }

    var soundId: SystemSoundID = 0
    let result = AudioServicesCreateSystemSoundID(url as CFURL, &soundId)

    guard result == kAudioServicesNoError
    else { throw Error.errorLoadingSound(result) }

    soundIds[sound] = soundId
  }

  func play(_ sound: Sound) throws {
    guard let soundId = soundIds[sound]
    else { throw Error.soundNotLoaded(sound) }
    AudioServicesPlaySystemSound(soundId)
  }
}

extension AudioService {
  enum Error: Swift.Error {
    case fileNotFound(Sound)
    case soundNotLoaded(Sound)
    case errorLoadingSound(OSStatus)
  }

  enum Sound: String, CaseIterable {
    case uiSfxButtonTap = "beep"
  }
}

extension View {
  func tapSound(_ sound: AudioService.Sound = .uiSfxButtonTap) -> some View {
    simultaneousGesture(
      TapGesture().onEnded {
        try? AudioService.shared.play(sound)
      }
    )
  }
}
