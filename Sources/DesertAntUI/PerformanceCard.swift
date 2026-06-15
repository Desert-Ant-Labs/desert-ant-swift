import SwiftUI

public struct PerformanceCard: View {
    let itemCount: Int
    let itemNoun: String
    let totalSeconds: Double
    let modelMsPerItem: Double
    let modelItemsPerSecond: Double
    let endToEndItemsPerSecond: Double
    let deviceName: String

    public init(itemCount: Int,
                itemNoun: String,
                totalSeconds: Double,
                modelMsPerItem: Double,
                modelItemsPerSecond: Double,
                endToEndItemsPerSecond: Double,
                deviceName: String = DeviceName.current) {
        self.itemCount = itemCount
        self.itemNoun = itemNoun
        self.totalSeconds = totalSeconds
        self.modelMsPerItem = modelMsPerItem
        self.modelItemsPerSecond = modelItemsPerSecond
        self.endToEndItemsPerSecond = endToEndItemsPerSecond
        self.deviceName = deviceName
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headline
            statRow
            Text("On \(deviceName)")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 14).fill(.background))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.separator, lineWidth: 0.5))
    }

    private var headline: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(itemCount)")
                .font(.system(size: 42, weight: .semibold, design: .rounded))
                .monospacedDigit()
            Text(itemNoun)
                .font(.title3)
                .foregroundStyle(.secondary)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.2f s", totalSeconds))
                    .font(.title3.weight(.medium))
                    .monospacedDigit()
                Text("end-to-end")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
        }
    }

    private var statRow: some View {
        HStack(spacing: 14) {
            Stat(label: "model",
                 value: String(format: "%.0f ms", modelMsPerItem),
                 subtitle: "per \(itemNounSingular)")
            Stat(label: "throughput",
                 value: String(format: "%.0f", modelItemsPerSecond),
                 subtitle: "\(itemNoun)/s (model)")
            Stat(label: "end-to-end",
                 value: String(format: "%.0f", endToEndItemsPerSecond),
                 subtitle: "\(itemNoun)/s (incl. decode)")
        }
    }

    private var itemNounSingular: String {
        if itemNoun.hasSuffix("s") {
            return String(itemNoun.dropLast())
        }
        return itemNoun
    }
}

public struct Stat: View {
    let label: String
    let value: String
    let subtitle: String

    public init(label: String, value: String, subtitle: String) {
        self.label = label
        self.value = value
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.title3.weight(.medium))
                .monospacedDigit()
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PerformanceCard(
        itemCount: 247,
        itemNoun: "photos",
        totalSeconds: 8.41,
        modelMsPerItem: 31.2,
        modelItemsPerSecond: 322,
        endToEndItemsPerSecond: 29.4
    )
    .padding()
}
