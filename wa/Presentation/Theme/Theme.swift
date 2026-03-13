import SwiftUI

struct AppTheme {
    static let spacing: CGFloat = 12
    static let cardCornerRadius: CGFloat = 16
    static let cardBorderAlpha: Double = 0.3
    static let cardBackgroundAlpha: Double = 0.85
    
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.gray
        static let background = Color(.systemBackground)
        static let cardBorder = Color.primary.opacity(cardBorderAlpha)
    }
}

extension View {
    func weatherCardStyle() -> some View {
        self
            .padding(AppTheme.spacing)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                    .fill(.ultraThinMaterial.opacity(AppTheme.cardBackgroundAlpha))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                    .stroke(Color.primary.opacity(AppTheme.cardBorderAlpha), lineWidth: 1)
            )
    }
    
    func glassmorphicBackground() -> some View {
        self
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                    .ignoresSafeArea()
            )
    }
}

// Helper for blur effect in SwiftUI
struct VisualEffectView: UIViewRepresentable {
    var effect: UIEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
