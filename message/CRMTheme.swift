import SwiftUI

/// Maps app theme colors to native system semantic colors for seamless Light/Dark mode.
struct CRMTheme {
#if os(macOS)
    static let primaryBackground = Color(NSColor.textBackgroundColor)
    static let primaryText = Color(NSColor.textColor)
    static let secondaryBackground = Color(NSColor.windowBackgroundColor)
    static let secondaryText = Color(NSColor.secondaryLabelColor)
    static let accent = Color(NSColor.controlAccentColor)
    static let border = Color(NSColor.textColor).opacity(0.0)
    static let invertedBackground = Color(NSColor.textColor)
    static let invertedText = Color(NSColor.textBackgroundColor)
#else
    static let primaryBackground = Color(UIColor.systemBackground)
    static let primaryText = Color(UIColor.label)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let secondaryText = Color(UIColor.secondaryLabel)
    static let accent = Color.accentColor
    static let border = Color(UIColor.label).opacity(0.0)
    static let invertedBackground = Color(UIColor.label)
    static let invertedText = Color(UIColor.systemBackground)
#endif
}

extension View {
    func crmBackground() -> some View {
        self.background(CRMTheme.primaryBackground)
    }
    
    func crmTextStyle() -> some View {
        self.foregroundColor(CRMTheme.primaryText)
    }
}
