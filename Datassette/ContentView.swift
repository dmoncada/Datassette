/*
import SwiftUI

struct ContentView: View {
  @State private var model = AppViewModel()

  var body: some View {
    #if os(macOS)
      macosLayout
    #else
      iosLayout
    #endif
  }
}

extension ContentView {
  @ViewBuilder
  fileprivate var macosLayout: some View {
    NavigationSplitView {
      Text("Hello, macOS!")

    } content: {
      Text("Content")

    } detail: {
      Text("Detail")
    }
  }
}

extension ContentView {
  @ViewBuilder
  fileprivate var iosLayout: some View {
  }

  private func printMetadata(for feed: DatassetteFeed) {
    let episodes = feed.episodes
    let totalDuration = episodes.map { Int($0.duration ?? 0) }.reduce(0, +)
    let totalHours = totalDuration / 3600
    let totalMins = (totalDuration % 3600) / 60
    let totalSecs = totalDuration % 60

    print("\(episodes.count) episodes")
    print("\(totalHours) hours")
    print("\(totalMins) minutes")
    print("\(totalSecs) seconds")
  }
}

#Preview {
  ContentView()
}
*/
