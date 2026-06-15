import Foundation

/// Marketing name for the current device, resolved from `utsname.machine`.
/// `"iPhone17,1"` → `"iPhone 16 Pro"`. Unmapped identifiers fall back to the
/// raw value.
public enum DeviceName {
    public static let current: String = marketing[rawIdentifier] ?? rawIdentifier

    public static var rawIdentifier: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return withUnsafePointer(to: &sysinfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { String(cString: $0) }
        }
    }

    private static let marketing: [String: String] = [
        // iPhone
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",
        "iPhone17,1": "iPhone 16 Pro",
        "iPhone17,2": "iPhone 16 Pro Max",
        "iPhone17,3": "iPhone 16",
        "iPhone17,4": "iPhone 16 Plus",
        "iPhone17,5": "iPhone 17",
        "iPhone17,6": "iPhone 17 Pro",
        "iPhone17,7": "iPhone 17 Pro Max",

        // iPad (M-series only — they're the ANE benchmarks we care about)
        "iPad14,3":   "iPad Pro 11\" (M2)",
        "iPad14,4":   "iPad Pro 11\" (M2)",
        "iPad14,5":   "iPad Pro 12.9\" (M2)",
        "iPad14,6":   "iPad Pro 12.9\" (M2)",
        "iPad16,3":   "iPad Pro 11\" (M4)",
        "iPad16,4":   "iPad Pro 11\" (M4)",
        "iPad16,5":   "iPad Pro 13\" (M4)",
        "iPad16,6":   "iPad Pro 13\" (M4)",

        // Simulator
        "arm64":      "Simulator (host arch)",
        "x86_64":     "Simulator (host arch)",
    ]
}
