import XCTest
@testable import DesertAntUI

final class DesertAntUITests: XCTestCase {
    func testMarkGeometryMatchesTheWebMark() {
        // packages/web/js/mark.js in Desert-Ant-Labs/brand is the source
        XCTAssertEqual(DA.MarkGeometry.plate, CGSize(width: 40, height: 38))
        XCTAssertEqual(DA.MarkGeometry.cornerRadius, 9)
        XCTAssertEqual(DA.MarkGeometry.cells.count, 7)
        XCTAssertEqual(DA.MarkGeometry.cells[0], CGRect(x: 17.9, y: 7.5, width: 4.2, height: 23))
    }

    func testLoaderTimingMatchesTheWebLoader() {
        XCTAssertEqual(DA.MarkLoader.cycle, 2.2, accuracy: 0.0001)
        XCTAssertEqual(DA.MarkLoader.stagger, 0.14, accuracy: 0.0001)
        // before its delay a cell waits off the top, clear
        let early = DA.MarkLoader.state(at: 0.1, cell: 6)
        XCTAssertEqual(early.opacity, 0)
        // mid-cycle every cell is settled and opaque
        let mid = DA.MarkLoader.state(at: 1.5, cell: 0)
        XCTAssertEqual(mid.dropY, 0)
        XCTAssertEqual(mid.opacity, 1)
    }

    func testSemanticColorsExist() {
        _ = DA.Color.textPrimary; _ = DA.Color.bgCanvas; _ = DA.Color.accent; _ = DA.Color.darkTeal
    }
}
