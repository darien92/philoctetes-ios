import SwiftUI

public struct PhilCard<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(PhilSpacing.md)
            .background(PhilColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: PhilSpacing.cornerRadiusMedium))
    }
}
