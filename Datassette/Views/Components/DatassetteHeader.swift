import SwiftUI

struct DatassetteHeader: View {
  private let width: Int

  init(charsPerLine: Int = 32) {
    self.width = charsPerLine
  }

  @AttributedStringBuilder
  var builder: AttributedString {
    "function".with(.color(.themeBlue), .italic)
    " "
    "musicFor".with(.color(.themeGreen))
    "("
    "task".with(.color(.themeOrange), .italic)
    " = "
    "'programming'".with(.color(.themeYellow))
    ") { "
    "return".with(.color(.themeFuschia))
    " "
    "`A series of mixes intended for listening while".with(.color(.themePurple))
    " "
    "${".with(.color(.themeYellow))
    "task"
    "}".with(.color(.themeYellow))
    " "
    "to focus the brain and inspire the mind.`".with(.color(.themePurple))
    "; }"
  }

  var body: some View {
    let wrapped = breakIntoLines(builder, lineWidth: width)

    VStack(alignment: .leading) {
      ForEach(wrapped.indices, id: \.self) { i in
        Text(wrapped[i])
      }
    }
  }
}

#Preview {
  DatassetteHeader()
    .font(.themeFont(size: 12).bold())
    .foregroundStyle(.themePrimary)
}
