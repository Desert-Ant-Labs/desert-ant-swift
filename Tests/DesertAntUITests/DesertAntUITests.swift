import XCTest
@testable import DesertAntUI

final class DesertAntUITests: XCTestCase {
    func testMarkGeometryMatchesTheWebMark() {
        // packages/web/js/mark.js in Desert-Ant-Labs/brand is the source
        XCTAssertEqual(DS.MarkGeometry.plate, CGSize(width: 40, height: 38))
        XCTAssertEqual(DS.MarkGeometry.cornerRadius, 9)
        XCTAssertEqual(DS.MarkGeometry.cells.count, 7)
        XCTAssertEqual(DS.MarkGeometry.cells[0], CGRect(x: 17.9, y: 7.5, width: 4.2, height: 23))
    }

    func testLoaderTimingMatchesTheWebLoader() {
        XCTAssertEqual(DS.MarkLoader.cycle, 2.2, accuracy: 0.0001)
        XCTAssertEqual(DS.MarkLoader.stagger, 0.14, accuracy: 0.0001)
        // before its delay a cell waits off the top, clear
        let early = DS.MarkLoader.state(at: 0.1, cell: 6)
        XCTAssertEqual(early.opacity, 0)
        // mid-cycle every cell is settled and opaque
        let mid = DS.MarkLoader.state(at: 1.5, cell: 0)
        XCTAssertEqual(mid.dropY, 0)
        XCTAssertEqual(mid.opacity, 1)
    }

    func testSemanticColorsExist() {
        _ = DS.Color.textPrimary; _ = DS.Color.bgCanvas; _ = DS.Color.accent; _ = DS.Color.darkTeal
    }
}
