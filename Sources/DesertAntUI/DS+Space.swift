import CoreGraphics

extension DS {
    /// 4-pt grid spacing. Tracks `design-system/tokens/spacing.css`.
    /// Names mirror the t-shirt scale (`s4` = 16pt = `--space-4`).
    public enum Space {
        public static let s0:  CGFloat = 0
        public static let sPx: CGFloat = 1
        public static let s1:  CGFloat = 4
        public static let s2:  CGFloat = 8
        public static let s3:  CGFloat = 12
        public static let s4:  CGFloat = 16
        public static let s5:  CGFloat = 20
        public static let s6:  CGFloat = 24
        public static let s7:  CGFloat = 28
        public static let s8:  CGFloat = 32
        public static let s10: CGFloat = 40
        public static let s12: CGFloat = 48
        public static let s14: CGFloat = 56
        public static let s16: CGFloat = 64
        public static let s20: CGFloat = 80
        public static let s24: CGFloat = 96
        public static let s32: CGFloat = 128
        public static let s40: CGFloat = 160
        public static let s48: CGFloat = 192

        /// Control heights (buttons / inputs).
        public enum Control {
            public static let sm: CGFloat = 32
            public static let md: CGFloat = 40
            public static let lg: CGFloat = 48
        }
    }

    /// Corner radii. Tracks `design-system/tokens/radius.css`.
    public enum Radius {
        public static let none: CGFloat = 0
        public static let xs:   CGFloat = 2
        public static let sm:   CGFloat = 4
        public static let md:   CGFloat = 6   // default control radius
        public static let lg:   CGFloat = 8   // default card radius
        public static let xl:   CGFloat = 12
        public static let xl2:  CGFloat = 16
        public static let xl3:  CGFloat = 24
        public static let full: CGFloat = 9999

        /// Hairline border width (used by iOS separators).
        public static let hairline: CGFloat = 0.5
    }

    /// Animation durations, in seconds. Tracks `design-system/tokens/motion.css`.
    public enum Duration {
        public static let instant: Double = 0.080
        public static let fast:    Double = 0.140
        public static let base:    Double = 0.220
        public static let slow:    Double = 0.340
        public static let slower:  Double = 0.520
    }

    /// iOS-specific layout metrics. Tracks `design-system/tokens/ios.css`.
    /// Only the values that translate sensibly to a SwiftUI app are exposed.
    public enum IOS {
        public static let gutter:       CGFloat = 16
        public static let insetGutter:  CGFloat = 16
        public static let rowH:         CGFloat = 44
        public static let rowHLg:       CGFloat = 58
        public static let rowHXl:       CGFloat = 72

        public static let radiusCard:    CGFloat = 12
        public static let radiusControl: CGFloat = 10
        public static let radiusTile:    CGFloat = 18

        // Type roles in points (Apple metrics, brand faces).
        public static let largeTitle: CGFloat = 34
        public static let title1:     CGFloat = 28
        public static let title2:     CGFloat = 22
        public static let title3:     CGFloat = 20
        public static let headline:   CGFloat = 17  // semibold
        public static let body:       CGFloat = 17
        public static let callout:    CGFloat = 16
        public static let subhead:    CGFloat = 15
        public static let footnote:   CGFloat = 13
        public static let caption1:   CGFloat = 12
        public static let caption2:   CGFloat = 11
    }
}
