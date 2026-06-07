import SwiftUI

extension String {
  func with(_ modifiers: AttributeModifier...) -> AttributedString {
    AttributedString(self)
      .with(modifiers)
  }
}

extension AttributedString {
  func with(_ modifiers: AttributeModifier...) -> AttributedString {
    with(modifiers)
  }

  func with(_ modifiers: [AttributeModifier]) -> AttributedString {
    var copy = self
    var container = AttributeContainer()
    modifiers.forEach { $0.apply(to: &container) }
    copy.mergeAttributes(container)
    return copy
  }
}

extension AttributedString {
  init(@AttributedStringBuilder _ content: () -> AttributedString) {
    self = content()
  }
}

extension Text {
  init(@AttributedStringBuilder _ content: () -> AttributedString) {
    self.init(content())
  }
}
