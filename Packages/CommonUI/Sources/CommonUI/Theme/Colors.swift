import SwiftUI

public enum PhilColors {
    // MARK: - Primary
    public static let primary = Color.blue
    public static let primaryVariant = Color.blue.opacity(0.8)
    public static let onPrimary = Color.white

    // MARK: - Secondary
    public static let secondary = Color.indigo
    public static let onSecondary = Color.white

    // MARK: - Background
    public static let background = Color(.systemBackground)
    public static let surface = Color(.secondarySystemBackground)
    public static let surfaceElevated = Color(.tertiarySystemBackground)

    // MARK: - Semantic
    public static let error = Color.red
    public static let success = Color.green
    public static let warning = Color.orange

    // MARK: - Text
    public static let textPrimary = Color(.label)
    public static let textSecondary = Color(.secondaryLabel)
    public static let textTertiary = Color(.tertiaryLabel)

    // MARK: - Calorie Tracking
    public static let caloriesConsumed = Color.orange
    public static let caloriesBurned = Color.green
    public static let caloriesRemaining = Color.blue
    public static let protein = Color.red
    public static let carbs = Color.yellow
    public static let fat = Color.purple
}
