import SwiftUI

struct DatassetteMarquee: View {
  private let text: String
  private let width: Int
  private let duration: Duration
  private let characters: [Character]

  @State private var offset = 0

  init(
    _ text: String,
    width: Int = 32,
    duration: Duration = .seconds(0.5),
  ) {
    self.text = text
    self.width = width
    self.duration = duration

    let unit = "\(text) • "
    let target = Double(width * 2)
    let needed = target / Double(unit.count)
    let repeats = max(2, Int(ceil(needed)))

    characters = Array(String(repeating: unit, count: repeats))
  }

  var body: some View {
    Text(displayString)
      .task {
        offset = 0
        while Task.isCancelled == false {
          try? await Task.sleep(for: duration)
          offset += 1
        }
      }
  }

  private var displayString: String {
    String(
      (0 ..< width).map { i in
        characters[(offset + i) % characters.count]
      }
    )
  }
}

#Preview {
  @Previewable @State var first = true

  VStack {
    let text =
      first
      ? "Hello, world!"
      : "This is a much longer marquee text"

    DatassetteMarquee(text, width: 20, duration: .seconds(0.25))
      .font(.themeFont(.body))
      .border(.red)
      .id(text)

    Button("Switch") {
      first.toggle()
    }
  }
}
