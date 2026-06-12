import SwiftUI

struct PreviewSheetWrapper<Content: View>: View {
  @State private var isPresented = false

  @ViewBuilder let content: () -> Content

  var body: some View {
    Button("Show sheet") {
      isPresented = true
    }
    .sheet(isPresented: $isPresented) {
      content()
        .presentationDetents([.medium, .large])
    }
  }
}
