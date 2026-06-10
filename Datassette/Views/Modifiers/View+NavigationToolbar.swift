import SwiftUI

struct NavigationToolbarModifier: ViewModifier {
  @Environment(\.dismiss) var dismiss

  let title: String

  func body(content: Content) -> some View {
    content
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Button(role: .close) {
          dismiss()
        }
      }
  }
}

extension View {
  func navigationToolbar(title: String) -> some View {
    modifier(NavigationToolbarModifier(title: title))
  }
}

#Preview {
  NavigationStack {
    Text("Hello, world!")
      .navigationToolbar(title: "Title")
  }
}
