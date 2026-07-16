import SwiftUI

struct TrustView: View {
    @EnvironmentObject private var store: JoinMeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                profileScore
                afterEventReview
                policyCards
            }
            .padding(16)
        }
        .background(JoinMeStyle.background)
        .navigationTitle("信用概念")
    }

    private var profileScore: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader("我的輕信用", caption: "讓人敢赴約，但不把社交變成考績。")

            HStack(spacing: 12) {
                AvatarBadge(profile: store.currentUser, size: 62)
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.currentUser.name)
                        .font(.title3.weight(.bold))
                    Text(store.currentUser.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack(spacing: 10) {
                ScoreBox(title: "鴿子指數", value: "\(store.currentUser.pigeonIndex)", caption: "越低越穩")
                ScoreBox(title: "準時度", value: "\(store.currentUser.punctuality)%", caption: "\(store.currentUser.completedEvents) 場完成")
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(store.currentUser.tags, id: \.self) { tag in
                        JMTag(text: tag)
                    }
                }
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private var afterEventReview: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("活動後互評入口")

            HStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title)
                    .foregroundStyle(JoinMeStyle.leaf)
                    .frame(width: 44, height: 44)
                    .background(JoinMeStyle.leaf.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text("跑咖互拍一小時")
                        .font(.headline)
                    Text("活動結束後，可評準時、溝通、是否完成委託。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button {
            } label: {
                Label("示範互評", systemImage: "slider.horizontal.3")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private var policyCards: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("規則提示")
            TrustPolicyRow(symbolName: "person.crop.circle.badge.clock", title: "臨時取消會被記錄", description: "MVP 只展示概念，正式版可加入寬限、申訴與合理原因。")
            TrustPolicyRow(symbolName: "archivebox", title: "聊天室會到期", description: "活動結束 24 小時後封存，降低無限延伸聊天的壓力。")
            TrustPolicyRow(symbolName: "text.badge.checkmark", title: "委託比個人魅力重要", description: "資訊結構化：時間、地點、人數、條件先講清楚。")
        }
    }
}

struct ScoreBox: View {
    var title: String
    var value: String
    var caption: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title.weight(.bold))
                .foregroundStyle(JoinMeStyle.ink)
            Text(caption)
                .font(.caption.weight(.semibold))
                .foregroundStyle(JoinMeStyle.leaf)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(JoinMeStyle.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct TrustPolicyRow: View {
    var symbolName: String
    var title: String
    var description: String

    var bodyView: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbolName)
                .font(.headline)
                .foregroundStyle(JoinMeStyle.coral)
                .frame(width: 32, height: 32)
                .background(JoinMeStyle.coral.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    var body: some View {
        bodyView
    }
}
