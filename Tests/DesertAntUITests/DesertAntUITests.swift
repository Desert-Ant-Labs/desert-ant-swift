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
        XCTAssertEqual(DA.Loader.cycle, 2.2, accuracy: 0.0001)
        XCTAssertEqual(DA.Loader.dropStagger, 0.14, accuracy: 0.0001)
        // before its delay a drop cell waits off the top, clear
        let drop = DA.Loader(.drop)
        XCTAssertEqual(drop.cellState(t: 0.1, cell: 6).opacity, 0)
        let mid = drop.cellState(t: 1.5, cell: 0)
        XCTAssertEqual(mid.dy, 0)
        XCTAssertEqual(mid.opacity, 1)
    }

    func testEveryLoaderVariantHasItsData() {
        XCTAssertEqual(DA.Loader.Variant.allCases.count, 15)
        XCTAssertEqual(LoaderData.fill.count, 25)
        XCTAssertEqual(LoaderData.tetris.count, 25)
        XCTAssertEqual(LoaderData.tetrisClear.count, 19)
        XCTAssertEqual(LoaderData.emergeSparse.count, 14)   // the mark px stay lit
        XCTAssertEqual(LoaderData.chase.count, 7)
        XCTAssertEqual(LoaderData.orbit.count, 6)
        // emerge-sparse: a negative delay starts mid-cycle; the value is defined at t = 0
        let track = LoaderData.emergeSparse["0-0"]!
        XCTAssertEqual(track.duration, 4.145, accuracy: 0.0001)
        XCTAssertEqual(track.delay, -1.36, accuracy: 0.0001)
        let v = DA.Loader.value(of: track, at: 0)
        XCTAssertGreaterThanOrEqual(v, 0.08)
        XCTAssertLessThanOrEqual(v, 1)
    }

    func testSemanticColorsExist() {
        _ = DA.Color.textPrimary; _ = DA.Color.bgCanvas; _ = DA.Color.accent; _ = DA.Color.darkTeal
    }
}
