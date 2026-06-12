import SwiftUI

struct DatassetteHeader: View {
  var width: Int = 32

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
    if width > 0 {
      VStack(alignment: .leading) {
        ForEach(builder.breakLine(width), id: \.self) { line in
          Text(line)
        }
      }

    } else {
      Text(builder)
    }
  }
}

#Preview {
  @Previewable @State var isDark = true

  VStack {
    Group {
      DatassetteHeader()

      ScrollView(.horizontal) {
        DatassetteHeader(width: 0)
          .frame(height: 50)
      }
    }
    .font(.themeFont(size: 12).bold())
    .foregroundStyle(.themePrimary)

    Button("Toggle scheme") {
      isDark.toggle()
    }
  }
  .padding()
  .background(.themeBackground)
  .preferredColorScheme(isDark ? .dark : .light)
}
