import SwiftUI

public struct PhilErrorView: View {
    private let message: String
    private let retryAction: (() -> Void)?

    public init(message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: PhilSpacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(PhilColors.error)

            Text(message)
                .font(PhilTypography.bodyMedium)
                .foregroundStyle(PhilColors.textSecondary)
                .multilineTextAlignment(.center)

            if let retryAction {
                PhilButton(title: "Retry", style: .secondary, action: retryAction)
                    .frame(width: 120)
            }
        }
        .padding(PhilSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
