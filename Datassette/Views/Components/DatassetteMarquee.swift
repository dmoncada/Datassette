import SwiftUI

struct DatassetteMarquee: View {
  let text: String
  let width: Int
  let duration: Duration
  let source: String
  let characters: [Character]

  @State private var offset = 0

  init(
    _ text: String,
    width: Int = 32,
    duration: Duration = .seconds(0.5)
  ) {
    self.text = text
    self.width = width
    self.duration = duration

    let unit = "\(text) • "
    let repeats = max(
      2,
      Int(ceil(Double(width * 2) / Double(unit.count)))
    )

    self.source = String(repeating: unit, count: repeats)
    self.characters = Array(self.source)
  }

  var body: some View {
    Text(displayString)
      .frame(alignment: .leading)
      .lineLimit(1)
      .minimumScaleFactor(1)
      .truncationMode(.tail)
      .allowsTightening(false)
      .clipped()
      .task {
        while Task.isCancelled == false {
          try? await Task.sleep(for: duration)
          offset += 1
        }
      }
  }

  private var displayString: String {
    return String(
      (0..<width).map { i in
        characters[(offset + i) % characters.count]
      }
    )
  }
}

#Preview {
  DatassetteMarquee("Hello, world!", width: 20)
    .font(.themeFont(size: 18))
    .border(.red)
}
