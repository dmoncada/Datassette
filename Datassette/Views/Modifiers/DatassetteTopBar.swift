import SwiftUI

struct DatassetteTitle: View {
  var body: some View {
    Text {
      "musicForProgramming".with(.color(.themeGreen), .italic)
      "();"
    }
  }
}

struct DatassetteTitleModifier: ViewModifier {
  @Environment(Router.self) private var router

  func body(content: Content) -> some View {
    content
      .toolbarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .title) {
          DatassetteTitle()
            .font(.themeFont(size: 12).bold())
            .foregroundStyle(.themePrimary)
            .padding(.vertical)
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button("Settings", systemImage: "gearshape") {
            router.sheetItem = .settings
          }
          .labelStyle(.iconOnly)
          .foregroundStyle(.themePrimary)
        }
      }
  }
}

extension View {
  func withDatassetteTopBar() -> some View {
    modifier(DatassetteTitleModifier())
  }
}

#Preview("Component") {
  DatassetteTitle()
    .font(.themeFont(size: 12).bold())
    .foregroundStyle(.themePrimary)
}

#Preview("Modifier") {
  NavigationStack {
    Text("Hello, world!")
      .withDatassetteTopBar()
  }
  .environment(Router())
}
