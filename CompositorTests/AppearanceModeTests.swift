import SwiftUI
import XCTest
@testable import Compositor

/// The Appearance submenu's stored choice: dark by default, the stored word wins, nonsense falls back to dark.
final class AppearanceModeTests: XCTestCase {
    private let key = "appearance"

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: key)
        super.tearDown()
    }

    func testTheDefaultIsDark() {
        UserDefaults.standard.removeObject(forKey: key)
        XCTAssertEqual(AppearanceMode.current, .dark)
    }

    func testTheStoredWordWins() {
        UserDefaults.standard.set("Light", forKey: key)
        XCTAssertEqual(AppearanceMode.current, .light)
        UserDefaults.standard.set("System", forKey: key)
        XCTAssertEqual(AppearanceMode.current, .system)
    }

    func testNonsenseFallsBackToDark() {
        UserDefaults.standard.set("plaid", forKey: key)
        XCTAssertEqual(AppearanceMode.current, .dark)
    }

    func testEveryModeHasAnAppearance() {
        XCTAssertNil(AppearanceMode.system.appearance)
        XCTAssertNotNil(AppearanceMode.dark.appearance)
        XCTAssertNotNil(AppearanceMode.light.appearance)
        XCTAssertNil(AppearanceMode.system.colorScheme)
        XCTAssertEqual(AppearanceMode.dark.colorScheme, .dark)
        XCTAssertEqual(AppearanceMode.light.colorScheme, .light)
    }
}
