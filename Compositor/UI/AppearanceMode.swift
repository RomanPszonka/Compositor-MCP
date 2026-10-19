import AppKit
import SwiftUI

/// The app's theme. Dark is the historical default; System follows the Mac's own
/// setting; Light is the paper-bright variant. Stored as `appearance` in defaults.
enum AppearanceMode: String, CaseIterable, Sendable {
    case system = "System"
    case dark = "Dark"
    case light = "Light"

    /// Nil follows the Mac. A named appearance pins the app, alerts and panels included.
    var appearance: NSAppearance? {
        switch self {
        case .system: nil
        case .dark: NSAppearance(named: .darkAqua)
        case .light: NSAppearance(named: .aqua)
        }
    }

    /// The same choice for SwiftUI content (the canvas chrome reads this).
    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .dark: .dark
        case .light: .light
        }
    }

    static var current: AppearanceMode {
        AppearanceMode(rawValue: UserDefaults.standard.string(forKey: "appearance") ?? "") ?? .dark
    }

    /// Whether the app is currently drawing dark — the pinned choice or, on System, the Mac's.
    static var isDark: Bool {
        NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) != .aqua
    }

    /// Applies the stored choice. Called at launch and from the Appearance submenu.
    static func applyStored() {
        NSApp.appearance = current.appearance
    }
}

extension NSColor {
    /// One gray per theme: the app's dark value where it has always been, a light value for Light.
    static func themed(dark: CGFloat, light: CGFloat, alpha: CGFloat = 1) -> NSColor {
        NSColor(name: nil) { appearance in
            let value = appearance.bestMatch(from: [.darkAqua, .aqua]) == .aqua ? light : dark
            return NSColor(white: value, alpha: alpha)
        }
    }
}
