import SwiftUI

public struct PhilLoadingView: View {
    private let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: PhilSpacing.md) {
            ProgressView()
                .controlSize(.large)

            if let message {
                Text(message)
                    .font(PhilTypography.bodyMedium)
                    .foregroundStyle(PhilColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
