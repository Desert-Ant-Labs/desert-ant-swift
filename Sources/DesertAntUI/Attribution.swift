import SwiftUI

/// The attribution lockup the model license asks for: the mark and the name.
///
///     DS.Attribution()                       // the mark and "Desert Ant Labs"
///     DS.Attribution(prefix: "Runs on")      // a muted lead-in
///
/// Wrap it in a `Link` to https://desertant.com where a tap makes sense. The
/// wordmark renders in the system font: the brand faces are not part of this
/// kit.
extension DS {
    public struct Attribution: View {
        let prefix: String?

        public init(prefix: String? = nil) { self.prefix = prefix }

        public var body: some View {
            HStack(spacing: 8) {
                if let prefix {
                    Text(prefix)
                        .font(.footnote)
                        .foregroundStyle(DS.Color.textMuted)
                }
                Mark(.plate).frame(height: 19)
                Text("Desert Ant Labs")
                    .font(.footnote.weight(.semibold))
                    .kerning(-0.2)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(prefix.map { "\($0) Desert Ant Labs" } ?? "Desert Ant Labs"))
        }
    }
}
