import SwiftUI

extension DS {
    /// Centered status block: SwarmLoader (or warning icon) + uppercase mono
    /// title + body subtitle. The brand-uniform "model loading / error /
    /// waiting" panel used across demos.
    public struct CenterStatus: View {
        let title: String
        let subtitle: String
        let isError: Bool

        public init(title: String, subtitle: String, isError: Bool = false) {
            self.title = title
            self.subtitle = subtitle
            self.isError = isError
        }

        public var body: some View {
            VStack(spacing: DS.Space.s4) {
                if isError {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundStyle(DS.Color.danger)
                } else {
                    DS.SwarmLoader()
                }
                DS.SectionLabel(title)
                Text(subtitle)
                    .font(DS.Font.sans(DS.Font.textSm))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DS.Color.textSecondary)
                    .padding(.horizontal, DS.Space.s8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    /// A determinate progress panel: SwarmLoader + uppercase phase label +
    /// large mono `done / total` counter + a thin bar.
    public struct ProgressPanel: View {
        let label: String
        let done: Int
        let total: Int

        public init(label: String, done: Int, total: Int) {
            self.label = label
            self.done = done
            self.total = total
        }

        public var body: some View {
            VStack(spacing: DS.Space.s4) {
                DS.SwarmLoader()
                DS.SectionLabel(label)
                Text("\(done) / \(total)")
                    .font(DS.Font.mono(DS.Font.text2xl, weight: .medium))
                    .foregroundStyle(DS.Color.textPrimary)
                ProgressView(value: Double(done), total: Double(max(1, total)))
                    .tint(DS.Color.accent)
                    .frame(maxWidth: 240)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, DS.Space.s8)
        }
    }

    /// A simple empty/initial-state placeholder: serif display title, body
    /// copy, optional action slot. Designed for the "pick photos" / "tap to
    /// start" moment a demo opens into.
    public struct EmptyHint<Action: View>: View {
        let title: String
        let body: String
        let action: () -> Action

        public init(title: String,
                    body: String,
                    @ViewBuilder action: @escaping () -> Action) {
            self.title = title
            self.body = body
            self.action = action
        }

        public var body: some View {
            VStack(spacing: DS.Space.s5) {
                VStack(spacing: DS.Space.s2) {
                    Text(title)
                        .font(DS.Font.display(26))
                        .foregroundStyle(DS.Color.textPrimary)
                        .multilineTextAlignment(.center)
                    Text(self.body)
                        .font(DS.Font.sans(DS.Font.textSm))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, DS.Space.s8)
                        .lineSpacing(2)
                }
                action()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
