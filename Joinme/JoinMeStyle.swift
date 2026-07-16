import SwiftUI

enum JoinMeStyle {
    static let background = Color(red: 0.97, green: 0.98, blue: 0.96)
    static let ink = Color(red: 0.12, green: 0.15, blue: 0.18)
    static let secondaryInk = Color(red: 0.42, green: 0.47, blue: 0.50)
    static let coral = Color(red: 0.96, green: 0.37, blue: 0.30)
    static let leaf = Color(red: 0.09, green: 0.64, blue: 0.56)
    static let sun = Color(red: 0.98, green: 0.72, blue: 0.20)
}

struct BrandGradient: View {
    var body: some View {
        LinearGradient(
            colors: [JoinMeStyle.coral, JoinMeStyle.sun, JoinMeStyle.leaf],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct JMTag: View {
    var text: String
    var isSelected: Bool = false

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(isSelected ? .white : JoinMeStyle.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .fill(isSelected ? JoinMeStyle.ink : .white)
                    .stroke(.black.opacity(0.08), lineWidth: isSelected ? 0 : 1)
            }
    }
}

struct AvatarBadge: View {
    var profile: UserProfile
    var size: CGFloat = 44

    var body: some View {
        Text(profile.avatar)
            .font(.system(size: size * 0.42, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [JoinMeStyle.leaf, JoinMeStyle.coral],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .accessibilityLabel(profile.name)
    }
}

struct MetricPill: View {
    var symbolName: String
    var text: String

    var body: some View {
        Label(text, systemImage: symbolName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(JoinMeStyle.secondaryInk)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.white.opacity(0.78), in: Capsule())
    }
}

struct SectionHeader: View {
    var title: String
    var caption: String?

    init(_ title: String, caption: String? = nil) {
        self.title = title
        self.caption = caption
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.headline)
            if let caption {
                Text(caption)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
