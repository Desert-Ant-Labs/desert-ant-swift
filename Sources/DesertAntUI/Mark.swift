import SwiftUI

/// The Desert Ant Labs mark: seven cells on a 40x38 plate with a 9pt corner.
///
/// Keep in step: the same geometry lives in the brand repo as markup
/// (packages/web/js/mark.js, MARK_SVG). A change there needs the same
/// change here.
extension DA {
    /// The mark's native geometry, in a 40x38 space. Cell 0 is the tall bar.
    public enum MarkGeometry {
        public static let plate = CGSize(width: 40, height: 38)
        public static let cornerRadius: CGFloat = 9
        public static let cells: [CGRect] = [
            CGRect(x: 17.9, y: 7.5, width: 4.2, height: 23),
            CGRect(x: 9.5, y: 12.43, width: 4.2, height: 4.42),
            CGRect(x: 26.3, y: 12.43, width: 4.2, height: 4.42),
            CGRect(x: 13.7, y: 16.72, width: 4.2, height: 4.43),
            CGRect(x: 22.1, y: 16.72, width: 4.2, height: 4.43),
            CGRect(x: 9.5, y: 21.15, width: 4.2, height: 4.42),
            CGRect(x: 26.3, y: 21.15, width: 4.2, height: 4.42),
        ]
    }

    /// The seven cells as one shape, scaled to the rect it is given.
    public struct MarkGlyph: Shape {
        public init() {}
        public func path(in rect: CGRect) -> Path {
            let sx = rect.width / MarkGeometry.plate.width
            let sy = rect.height / MarkGeometry.plate.height
            var p = Path()
            for c in MarkGeometry.cells {
                p.addRect(CGRect(x: rect.minX + c.minX * sx, y: rect.minY + c.minY * sy,
                                 width: c.width * sx, height: c.height * sy))
            }
            return p
        }
    }

    /// The mark. `.plate` is the default: the glyph on a plate tinted at 10%.
    /// `.inverted` fills the plate solid and knocks the glyph out to the
    /// background. `.isolated` is the glyph alone. Color comes from the
    /// environment foreground, so on a dark surface the mark turns light on
    /// its own.
    public struct Mark: View {
        public enum Variant { case plate, inverted, isolated }
        let variant: Variant

        public init(_ variant: Variant = .plate) { self.variant = variant }

        public var body: some View {
            GeometryReader { geo in
                let rect = CGRect(origin: .zero, size: geo.size)
                let radius = MarkGeometry.cornerRadius * geo.size.width / MarkGeometry.plate.width
                switch variant {
                case .plate:
                    RoundedRectangle(cornerRadius: radius, style: .continuous).opacity(0.1)
                    MarkGlyph().path(in: rect)
                case .inverted:
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(.foreground)
                        .reverseMask { MarkGlyph() }
                case .isolated:
                    MarkGlyph().path(in: rect)
                }
            }
            .aspectRatio(MarkGeometry.plate.width / MarkGeometry.plate.height, contentMode: .fit)
            .accessibilityHidden(true)
        }
    }
}

extension View {
    /// Cuts `mask` out of the view, so the glyph shows the background through the plate.
    fileprivate func reverseMask<M: View>(@ViewBuilder _ mask: () -> M) -> some View {
        self.mask {
            Rectangle().overlay(mask().blendMode(.destinationOut))
        }
    }
}
