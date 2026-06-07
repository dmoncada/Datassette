import SwiftUI

extension ShapeStyle where Self == Color {
  static var themeBlack: Color { Color(.Datassette.black) }
  static var themeBlue: Color { Color(.Datassette.blue) }
  static var themeFuschia: Color { Color(.Datassette.fuschia) }
  static var themeGreen: Color { Color(.Datassette.green) }
  static var themeGrey: Color { Color(.Datassette.grey) }
  static var themeOrange: Color { Color(.Datassette.orange) }
  static var themePurple: Color { Color(.Datassette.purple) }
  static var themeYellow: Color { Color(.Datassette.yellow) }
  static var themeWhite: Color { Color(.Datassette.white) }

  // Semantic
  static var themePrimary: Color { .themeWhite }
  static var themeSecondary: Color { .themeGrey }
  static var themeBackground: Color { .themeBlack }
}
