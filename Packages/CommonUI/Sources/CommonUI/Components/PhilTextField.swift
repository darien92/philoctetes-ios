import SwiftUI

public struct PhilTextField: View {
    private let label: String
    private let placeholder: String
    @Binding private var text: String
    private let isSecure: Bool
    private let errorMessage: String?
    private let keyboardType: UIKeyboardType

    public init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        isSecure: Bool = false,
        errorMessage: String? = nil,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.errorMessage = errorMessage
        self.keyboardType = keyboardType
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: PhilSpacing.xxs) {
            Text(label)
                .font(PhilTypography.labelMedium)
                .foregroundStyle(PhilColors.textSecondary)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding(PhilSpacing.sm)
            .background(PhilColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: PhilSpacing.cornerRadiusSmall))
            .overlay(
                RoundedRectangle(cornerRadius: PhilSpacing.cornerRadiusSmall)
                    .stroke(errorMessage != nil ? PhilColors.error : .clear, lineWidth: 1)
            )

            if let errorMessage {
                Text(errorMessage)
                    .font(PhilTypography.caption)
                    .foregroundStyle(PhilColors.error)
            }
        }
    }
}
