import SwiftUI

struct AboutView: View {
  var body: some View {
    ScrollView(.vertical) {
      Text(
        """
        Through years of trial and error — skipping around radio streams, playing entire collections on shuffle, or repeating certain tracks over and over — we have found that the most compelling music for sustained concentration tends to contain a mixture of the following:

        Noise
        Drones
        Arpeggios
        Atmospheres
        Field Recordings
        Arrhythmic Textures
        Vagueness (Hypnagogia)
        Microtones / Dissonance
        Detail / Finery / Patterns
        Awesome / Daunting / Foreboding
        Vast / Transcendental / Meditative

        Music possessing the above qualities can provide just the right amount of cognitive load to engage the parts of your mind that would otherwise be left free to wander and lead to distraction.

        The goal of this series is \(Text("not").foregroundStyle(.themeOrange).italic()) to present music as disposable background noise to be mostly ignored or tuned out, but the complete opposite — the goal is to present music that can \(Text("engulf").foregroundStyle(.themeGreen).italic()) the listener, carefully selected works that can be fully appreciated (perhaps even enhanced) despite sometimes only having peripheral attention paid to them.

        To be fully engaged in your own creative or logical challenges, while at the same time fully on board the emotional rails of the musical ideas of another person can make for an experience not dissimilar to meditation — but rather than focussing on the simplicity of nothingness while swatting away introspective daydreams, you are engulfed in enough complexity to cause introspective daydreams to burn up on re-entry.

        Your experience may be different / your milage may vary.
        """
      )
    }
  }
}

struct AboutSheet: View {
  var body: some View {
    NavigationStack {
      AboutView()
        .padding()
        .font(.themeFont(size: 12))
        .navigationToolbar(title: "About")
    }
  }
}

#Preview("Component") {
  NavigationStack {
    AboutView()
      .padding()
      .font(.themeFont(size: 12))
      .navigationTitle("About")
      .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview("Sheet") {
  @Previewable @State var isPresented = false

  Button("Show sheet") {
    isPresented = true
  }
  .sheet(isPresented: $isPresented) {
    AboutSheet()
  }
}
