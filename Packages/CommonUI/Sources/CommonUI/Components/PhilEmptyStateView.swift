import SwiftUI

public struct PhilEmptyStateView: View {
    private let icon: String
    private let title: String
    private let message: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        icon: String = "tray",
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: PhilSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(PhilColors.textTertiary)

            Text(title)
                .font(PhilTypography.headlineSmall)
                .foregroundStyle(PhilColors.textPrimary)

            Text(message)
                .font(PhilTypography.bodyMedium)
                .foregroundStyle(PhilColors.textSecondary)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                PhilButton(title: actionTitle, action: action)
                    .frame(width: 200)
            }
        }
        .padding(PhilSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
