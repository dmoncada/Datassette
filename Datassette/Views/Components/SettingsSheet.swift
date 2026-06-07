import SwiftUI

struct SettingsSheet: View {
  @AppStorage("colorSchemePreference")
  private var preference: ColorSchemePreference = .system

  var body: some View {
    NavigationStack {
      Form {
        /*
        Section {
          Picker("Theme", selection: $preference) {
            Group {
              Text("System").tag(ColorSchemePreference.system)
              Text("Light").tag(ColorSchemePreference.light)
              Text("Dark").tag(ColorSchemePreference.dark)
            }
            .containerBackground(.clear, for: .navigation)
          }
          .pickerStyle(.navigationLink)

        } footer: {
          Text("Controls the app's theme preference.")
        }
         */
        
        Section {
          NavigationLink {
            ThemeSelectionView(selection: $preference)
              .navigationTitle("Theme")

          } label: {
            HStack {
              Text("Theme")
                .frame(maxWidth: .infinity, alignment: .leading)

              Text(preference.displayName)
                .foregroundStyle(.themeSecondary)
            }
          }

        } footer: {
          Text("Controls the app's theme preference.")
        }

        Section {
          NavigationLink("About") {
            AboutView()
              .padding()
              .font(.themeFont(size: 12))
              .navigationTitle("About")
          }
        }
      }
      .preferredColorScheme(preference.colorScheme)
      .navigationToolbar(title: "Settings")
    }
  }
}

struct ThemeSelectionView: View {
  @Binding var selection: ColorSchemePreference

  var body: some View {
    List {
      ForEach(ColorSchemePreference.allCases) { option in
        Button {
          selection = option

        } label: {
          HStack {
            Text(option.displayName)
              .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "checkmark")
              .opacity(selection == option ? 1 : 0)
          }
        }
        .foregroundStyle(.primary)
      }
    }
  }
}

extension SettingsSheet {
  fileprivate struct Preview: View {
    @AppStorage("colorSchemePreference")
    private var preference: ColorSchemePreference = .system

    @State var isPresented = false

    var body: some View {
      Button("Show sheet") {
        isPresented = true
      }
      .sheet(isPresented: $isPresented) {
        SettingsSheet()
          .presentationDetents([.medium, .large])
      }
      .preferredColorScheme(preference.colorScheme)
    }
  }
}

#Preview {
  SettingsSheet.Preview()
}
