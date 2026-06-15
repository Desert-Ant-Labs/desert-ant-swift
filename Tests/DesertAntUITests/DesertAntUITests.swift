import XCTest
@testable import DesertAntUI

final class DesertAntUITests: XCTestCase {
    func testTokensAreFinite() {
        XCTAssertEqual(DS.Space.s4, 16)
        XCTAssertEqual(DS.Radius.lg, 8)
        XCTAssertEqual(DS.Duration.base, 0.220, accuracy: 0.0001)
        XCTAssertEqual(DS.Font.text2xs, 11)
    }

    func testSectionLabelInitializes() {
        let label = DS.SectionLabel("on-device")
        _ = label.body
    }
}
