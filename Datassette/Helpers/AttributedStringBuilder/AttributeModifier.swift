import SwiftUI

enum AttributeModifier {
  case bold
  case italic
  case font(Font)
  case color(Color)

  func apply(to container: inout AttributeContainer) {
    switch self {
    case .bold:
      container.inlinePresentationIntent = .stronglyEmphasized

    case .italic:
      container.inlinePresentationIntent = .emphasized

    case .font(let font):
      container.font = font

    case .color(let color):
      container.foregroundColor = color
    }
  }
}
