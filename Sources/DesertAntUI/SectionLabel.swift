import SwiftUI

extension DS {
    /// The recurring brand eyebrow: uppercase JetBrains Mono, wider tracking,
    /// muted color. The "coordinate / instrument-label" voice that runs above
    /// section headers and stat values across every Desert Ant Labs surface.
    ///
    ///     SectionLabel("on-device photo ranking")
    ///
    public struct SectionLabel: View {
        let text: String
        let size: CGFloat
        let color: SwiftUI.Color?

        public init(_ text: String, size: CGFloat = DS.Font.text2xs, color: SwiftUI.Color? = nil) {
            self.text = text
            self.size = size
            self.color = color
        }

        public var body: some View {
            Text(text.uppercased())
                .font(DS.Font.mono(size, weight: .medium))
                .kerning(DS.Font.trackingWider * size)
                .foregroundStyle(color ?? DS.Color.textMuted)
        }
    }

    /// A (value, label) pair in the brand voice: mono numeral over a tiny
    /// uppercase mono label. Used in stats bars and metric rows.
    ///
    ///     StatLabel(value: "12.4s", label: "wall clock")
    ///
    public struct StatLabel: View {
        let value: String
        let label: String
        let valueSize: CGFloat
        let labelSize: CGFloat

        public init(value: String,
                    label: String,
                    valueSize: CGFloat = 18,
                    labelSize: CGFloat = 9) {
            self.value = value
            self.label = label
            self.valueSize = valueSize
            self.labelSize = labelSize
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(DS.Font.mono(valueSize, weight: .medium))
                    .foregroundStyle(DS.Color.textPrimary)
                SectionLabel(label, size: labelSize)
            }
        }
    }
}
