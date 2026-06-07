import SwiftUI

struct DownloadStateIndicator: View {
  let state: DownloadService.State

  var body: some View {
    Group {
      switch state {
      case .idle:
        EmptyView()

      case .downloading:
        ProgressView()
          .controlSize(.small)
          .tint(.themeSecondary)

      case .downloaded:
        Image(systemName: "arrow.down.circle.fill")
          .foregroundStyle(.themeSecondary)
      }
    }
    .opacity(state == .idle ? 0 : 1)
  }
}

#Preview {
  HStack {
    DownloadStateIndicator(state: .idle)
    DownloadStateIndicator(state: .downloading)
    DownloadStateIndicator(state: .downloaded)
  }
}
