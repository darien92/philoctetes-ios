import SwiftUI

public enum PhilButtonStyle {
    case primary
    case secondary
    case destructive
    case text
}

public struct PhilButton: View {
    private let title: String
    private let style: PhilButtonStyle
    private let isLoading: Bool
    private let isEnabled: Bool
    private let action: () -> Void

    public init(
        title: String,
        style: PhilButtonStyle = .primary,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: PhilSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
                Text(title)
                    .font(PhilTypography.labelLarge)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, PhilSpacing.sm)
            .padding(.horizontal, PhilSpacing.md)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: PhilSpacing.cornerRadiusMedium))
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return PhilColors.caloriesRemaining
        case .secondary: return PhilColors.surface
        case .destructive: return PhilColors.error
        case .text: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return PhilColors.textPrimary
        case .destructive: return .white
        case .text: return PhilColors.caloriesRemaining
        }
    }
}
