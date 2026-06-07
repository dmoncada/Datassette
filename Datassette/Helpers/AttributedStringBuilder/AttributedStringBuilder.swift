import SwiftUI

@resultBuilder
enum AttributedStringBuilder {
  static func buildBlock(_ components: AttributedString...) -> AttributedString {
    components.reduce(into: AttributedString()) { result, part in
      result.append(part)
    }
  }

  static func buildExpression(_ expression: String) -> AttributedString {
    AttributedString(expression)
  }

  static func buildExpression(_ expression: AttributedString) -> AttributedString {
    expression
  }

  static func buildOptional(_ component: AttributedString?) -> AttributedString {
    component ?? AttributedString()
  }

  static func buildEither(first component: AttributedString) -> AttributedString {
    component
  }

  static func buildEither(second component: AttributedString) -> AttributedString {
    component
  }

  static func buildArray(_ components: [AttributedString]) -> AttributedString {
    components.reduce(into: AttributedString()) { result, part in
      result.append(part)
    }
  }
}
