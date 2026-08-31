// Desert Ant Labs design tokens. Generated from packages/tokens/src by build.mjs. Do not edit.
import SwiftUI

public enum DesignTokens {
    public enum Colors {
        public static let colorCream = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorInk = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 1)
        public static let colorSage = Color(red: 0.6784, green: 0.7059, blue: 0.6118, opacity: 1)
        public static let colorTeal = Color(red: 0.7647, green: 0.8275, blue: 0.8078, opacity: 1)
        public static let colorForest = Color(red: 0.0941, green: 0.1176, blue: 0.1137, opacity: 1)
        public static let colorTerracotta = Color(red: 0.8588, green: 0.4392, blue: 0.298, opacity: 1)
        public static let colorSand = Color(red: 0.8392, green: 0.8157, blue: 0.7647, opacity: 1)
        public static let colorWarmGrey = Color(red: 0.7176, green: 0.7137, blue: 0.7059, opacity: 1)
        public static let colorClayRed = Color(red: 0.8353, green: 0.2157, blue: 0.0706, opacity: 1)
        public static let colorEucalyptus = Color(red: 0.4118, green: 0.5412, blue: 0.502, opacity: 1)
        public static let colorDarkTeal = Color(red: 0.1098, green: 0.3216, blue: 0.3647, opacity: 1)
        public static let colorMist = Color(red: 0.3412, green: 0.3765, blue: 0.4157, opacity: 1)
        public static let colorPaper = Color(red: 0.9882, green: 0.9843, blue: 0.9686, opacity: 1)
        public static let colorBlack = Color(red: 0, green: 0, blue: 0, opacity: 1)
        public static let colorWhite = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let colorBgCanvas = Color(light: (0.9843, 0.9804, 0.9569, 1), dark: (0.0941, 0.1176, 0.1137, 1))
        public static let colorBgSurface = Color(light: (0.9882, 0.9843, 0.9686, 1), dark: (0.1216, 0.149, 0.1412, 1))
        public static let colorBgRaised = Color(light: (1, 1, 1, 1), dark: (0.149, 0.1804, 0.1725, 1))
        public static let colorBgSunken = Color(light: (0.949, 0.9451, 0.9176, 1), dark: (0.0706, 0.0902, 0.0863, 1))
        public static let colorBgInset = Color(light: (0.9137, 0.9098, 0.8784, 1), dark: (0.1686, 0.2, 0.1922, 1))
        public static let colorBgInverse = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorBgAccent = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorBgAccentSoft = Color(light: (0.0549, 0.0667, 0.0745, 0.051), dark: (0.9843, 0.9804, 0.9569, 0.0784))
        public static let colorBgTint = Color(light: (0.0549, 0.0667, 0.0745, 0.051), dark: (0.9843, 0.9804, 0.9569, 0.0784))
        public static let colorBgPlaceholder = Color(red: 0.9294, green: 0.9294, blue: 0.9294, opacity: 1)
        public static let colorTextPrimary = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorTextSecondary = Color(light: (0.1725, 0.1922, 0.2039, 1), dark: (0.8431, 0.8588, 0.851, 1))
        public static let colorTextMuted = Color(light: (0.3412, 0.3765, 0.4157, 1), dark: (0.6039, 0.6471, 0.6314, 1))
        public static let colorTextFaint = Color(light: (0.6039, 0.6314, 0.6471, 1), dark: (0.4314, 0.4745, 0.4588, 1))
        public static let colorTextInverse = Color(light: (0.9843, 0.9804, 0.9569, 1), dark: (0.0549, 0.0667, 0.0745, 1))
        public static let colorTextAccent = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorTextOnAccent = Color(light: (0.9843, 0.9804, 0.9569, 1), dark: (0.0549, 0.0667, 0.0745, 1))
        public static let colorBorderSubtle = Color(light: (0.0549, 0.0667, 0.0745, 0.102), dark: (0.9843, 0.9804, 0.9569, 0.1216))
        public static let colorBorderDefault = Color(light: (0.0549, 0.0667, 0.0745, 0.2), dark: (0.9843, 0.9804, 0.9569, 0.2392))
        public static let colorBorderStrong = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorBorderInverse = Color(light: (0.9843, 0.9804, 0.9569, 0.2), dark: (0.0549, 0.0667, 0.0745, 0.2))
        public static let colorBorderAccent = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorAccentDefault = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorAccentHover = Color(light: (0.1725, 0.1922, 0.2039, 1), dark: (1, 1, 1, 1))
        public static let colorAccentPress = Color(light: (0, 0, 0, 1), dark: (0.7647, 0.8275, 0.8078, 1))
        public static let colorAccentContrast = Color(light: (0.9843, 0.9804, 0.9569, 1), dark: (0.0549, 0.0667, 0.0745, 1))
        public static let colorFocusRing = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorSelectionBg = Color(light: (0.7647, 0.8275, 0.8078, 1), dark: (0.1961, 0.2588, 0.2745, 1))
        public static let colorSelectionFg = Color(light: (0.0549, 0.0667, 0.0745, 1), dark: (0.9843, 0.9804, 0.9569, 1))
        public static let colorSignalSuccess = Color(red: 0.2353, green: 0.5412, blue: 0.3216, opacity: 1)
        public static let colorSignalWarning = Color(red: 0.7608, green: 0.4118, blue: 0.102, opacity: 1)
        public static let colorSignalDanger = Color(red: 0.7451, green: 0.2275, blue: 0.1804, opacity: 1)
        public static let colorSignalInfo = Color(red: 0.1176, green: 0.549, blue: 0.549, opacity: 1)
        public static let colorThemeSageFill = Color(red: 0.6784, green: 0.7059, blue: 0.6118, opacity: 1)
        public static let colorThemeSageInk = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 1)
        public static let colorThemeSageSub = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.702)
        public static let colorThemeSageLine = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.102)
        public static let colorThemeTealFill = Color(red: 0.7647, green: 0.8275, blue: 0.8078, opacity: 1)
        public static let colorThemeTealInk = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 1)
        public static let colorThemeTealSub = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.651)
        public static let colorThemeTealLine = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.102)
        public static let colorThemeForestFill = Color(red: 0.0941, green: 0.1176, blue: 0.1137, opacity: 1)
        public static let colorThemeForestInk = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorThemeForestSub = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.549)
        public static let colorThemeForestLine = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.1216)
        public static let colorThemeTerracottaFill = Color(red: 0.8588, green: 0.4392, blue: 0.298, opacity: 1)
        public static let colorThemeTerracottaInk = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorThemeTerracottaSub = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.851)
        public static let colorThemeTerracottaLine = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.2)
        public static let colorThemeSandFill = Color(red: 0.8392, green: 0.8157, blue: 0.7647, opacity: 1)
        public static let colorThemeSandInk = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 1)
        public static let colorThemeSandSub = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.651)
        public static let colorThemeSandLine = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.102)
        public static let colorThemeWarmGreyFill = Color(red: 0.7176, green: 0.7137, blue: 0.7059, opacity: 1)
        public static let colorThemeWarmGreyInk = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 1)
        public static let colorThemeWarmGreySub = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.702)
        public static let colorThemeWarmGreyLine = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.102)
        public static let colorThemeClayRedFill = Color(red: 0.8353, green: 0.2157, blue: 0.0706, opacity: 1)
        public static let colorThemeClayRedInk = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorThemeClayRedSub = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorThemeClayRedLine = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.2)
        public static let colorThemeEucalyptusFill = Color(red: 0.4118, green: 0.5412, blue: 0.502, opacity: 1)
        public static let colorThemeEucalyptusInk = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorThemeEucalyptusSub = Color(red: 0.0549, green: 0.0667, blue: 0.0745, opacity: 0.9216)
        public static let colorThemeEucalyptusLine = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.1216)
        public static let colorThemeDarkTealFill = Color(red: 0.1098, green: 0.3216, blue: 0.3647, opacity: 1)
        public static let colorThemeDarkTealInk = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 1)
        public static let colorThemeDarkTealSub = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.702)
        public static let colorThemeDarkTealLine = Color(red: 0.9843, green: 0.9804, blue: 0.9569, opacity: 0.1216)
    }
    public enum Metrics {
        public static let fontSize2xs: CGFloat = 11
        public static let fontSizeXs: CGFloat = 12
        public static let fontSizeSm: CGFloat = 14
        public static let fontSizeBase: CGFloat = 16
        public static let fontSizeLg: CGFloat = 18
        public static let fontSizeXl: CGFloat = 24
        public static let fontSize2xl: CGFloat = 32
        public static let fontSize3xl: CGFloat = 40
        public static let fontSize4xl: CGFloat = 56
        public static let fontSize5xl: CGFloat = 72
        public static let fontSize6xl: CGFloat = 96
        public static let fontSize7xl: CGFloat = 120
        public static let space0: CGFloat = 0
        public static let space1: CGFloat = 4
        public static let space2: CGFloat = 8
        public static let space3: CGFloat = 12
        public static let space4: CGFloat = 16
        public static let space5: CGFloat = 20
        public static let space6: CGFloat = 24
        public static let space7: CGFloat = 28
        public static let space8: CGFloat = 32
        public static let space10: CGFloat = 40
        public static let space12: CGFloat = 48
        public static let space14: CGFloat = 56
        public static let space16: CGFloat = 64
        public static let space18: CGFloat = 72
        public static let space20: CGFloat = 80
        public static let space24: CGFloat = 96
        public static let space25: CGFloat = 100
        public static let space28: CGFloat = 112
        public static let space32: CGFloat = 128
        public static let space40: CGFloat = 160
        public static let space48: CGFloat = 192
        public static let spacePx: CGFloat = 1
        public static let containerSm: CGFloat = 640
        public static let containerMd: CGFloat = 820
        public static let containerLg: CGFloat = 1080
        public static let containerXl: CGFloat = 1172
        public static let container2xl: CGFloat = 1480
        public static let controlSm: CGFloat = 32
        public static let controlMd: CGFloat = 40
        public static let controlLg: CGFloat = 48
        public static let radiusNone: CGFloat = 0
        public static let radiusXs: CGFloat = 2
        public static let radiusSm: CGFloat = 4
        public static let radiusMd: CGFloat = 8
        public static let radiusLg: CGFloat = 12
        public static let radiusXl: CGFloat = 16
        public static let radius2xl: CGFloat = 24
        public static let radius3xl: CGFloat = 32
        public static let radiusPill: CGFloat = 40
        public static let radiusFull: CGFloat = 9999
        public static let borderHair: CGFloat = 1
        public static let borderThin: CGFloat = 1.5
        public static let borderThick: CGFloat = 2
        public static let blurSm: CGFloat = 6
        public static let blurMd: CGFloat = 14
        public static let blurLg: CGFloat = 28
        public static let fontWeightLight: CGFloat = 300
        public static let fontWeightRegular: CGFloat = 400
        public static let fontWeightMedium: CGFloat = 500
        public static let fontWeightSemibold: CGFloat = 600
        public static let fontWeightBold: CGFloat = 700
        public static let fontLeadingNone: CGFloat = 1
        public static let fontLeadingDisplay: CGFloat = 0.9
        public static let fontLeadingTight: CGFloat = 1.06
        public static let fontLeadingSnug: CGFloat = 1.2
        public static let fontLeadingNormal: CGFloat = 1.4
        public static let fontLeadingRelaxed: CGFloat = 1.7
        public static let durationInstant: TimeInterval = 0.08
        public static let durationFast: TimeInterval = 0.14
        public static let durationBase: TimeInterval = 0.22
        public static let durationSlow: TimeInterval = 0.34
        public static let durationSlower: TimeInterval = 0.52
        public static let durationLoader: TimeInterval = 2.2
    }
    public enum Fonts {
        public static let fontFamilyDisplay = "Inclusive Sans"
        public static let fontFamilyMono = "JetBrains Mono"
        public static let fontFamilyUi = "-apple-system"
    }
}

private extension Color {
    init(light: (Double, Double, Double, Double), dark: (Double, Double, Double, Double)) {
        #if canImport(UIKit)
        self.init(UIColor { trait in
            let c = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: c.0, green: c.1, blue: c.2, alpha: c.3)
        })
        #else
        self.init(NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
            let c = isDark ? dark : light
            return NSColor(red: c.0, green: c.1, blue: c.2, alpha: c.3)
        })
        #endif
    }
}
