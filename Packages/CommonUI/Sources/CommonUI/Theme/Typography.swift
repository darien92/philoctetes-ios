import SwiftUI

public enum PhilTypography {
    // MARK: - Display
    public static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    public static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)

    // MARK: - Headings
    public static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
    public static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
    public static let headlineSmall = Font.system(size: 17, weight: .semibold, design: .rounded)

    // MARK: - Body
    public static let bodyLarge = Font.system(size: 17, weight: .regular)
    public static let bodyMedium = Font.system(size: 15, weight: .regular)
    public static let bodySmall = Font.system(size: 13, weight: .regular)

    // MARK: - Labels
    public static let labelLarge = Font.system(size: 15, weight: .medium)
    public static let labelMedium = Font.system(size: 13, weight: .medium)
    public static let labelSmall = Font.system(size: 11, weight: .medium)

    // MARK: - Caption
    public static let caption = Font.system(size: 12, weight: .regular)
}
