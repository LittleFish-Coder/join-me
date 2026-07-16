import SwiftUI

struct CommissionDetailView: View {
    @Environment(JoinMeStore.self) private var store
    var commissionID: UUID
    @Binding var selectedTab: AppTab
    @State private var note = "我可以準時到，想用低壓方式一起完成這個委託。"

    private var commission: JoinCommission? {
        store.commission(id: commissionID)
    }

    private var status: JoinRequestStatus {
        store.applicationStatus(for: commissionID)
    }

    var body: some View {
        if let commission {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    titleBlock(commission)
                    hostBlock(commission.host)
                    detailRows(commission)
                    descriptionBlock(commission)
                    applyBlock(commission)
                }
                .padding(16)
            }
            .background(JoinMeStyle.background)
            .navigationTitle("委託詳情")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView("找不到這張委託", systemImage: "doc.text.magnifyingglass")
        }
    }

    private func titleBlock(_ commission: JoinCommission) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                BrandGradient()
                    .frame(width: 46, height: 46)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.white)
                    }
                Spacer()
                if commission.isHostedByCurrentUser {
                    Label("我發起的", systemImage: "megaphone.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(JoinMeStyle.leaf)
                }
            }

            Text(commission.title)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(JoinMeStyle.ink)
                .fixedSize(horizontal: false, vertical: true)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(commission.tags, id: \.self) { tag in
                        JMTag(text: tag)
                    }
                }
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private func hostBlock(_ host: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("發起人")
            HStack(spacing: 12) {
                AvatarBadge(profile: host, size: 54)
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(host.name) \(host.handle)")
                        .font(.headline)
                    Text("\(host.biologicalSex.rawValue) · \(host.age) 歲 · \(host.neighborhood)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(JoinMeStyle.leaf)
                    Text(host.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack(spacing: 8) {
                MetricPill(symbolName: "exclamationmark.triangle", text: "鴿子指數 \(host.pigeonIndex)")
                MetricPill(symbolName: "timer", text: "準時度 \(host.punctuality)%")
            }
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private func detailRows(_ commission: JoinCommission) -> some View {
        VStack(spacing: 10) {
            DetailRow(symbolName: "mappin.and.ellipse", title: "地區", value: "\(commission.area) · \(commission.place)")
            DetailRow(symbolName: "clock", title: "時間", value: commission.timeText)
            DetailRow(symbolName: "person.2", title: "人數", value: commission.participantText)
            DetailRow(symbolName: "checklist", title: "條件", value: commission.requirement)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private func descriptionBlock(_ commission: JoinCommission) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("委託說明")
            Text(commission.summary)
                .font(.body)
                .foregroundStyle(JoinMeStyle.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private func applyBlock(_ commission: JoinCommission) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("投遞狀態", caption: status.label)

            if commission.isHostedByCurrentUser {
                Text("這張是你發起的委託，可以到審核分頁查看申請者。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button {
                    selectedTab = .review
                } label: {
                    Label("前往審核", systemImage: "person.crop.circle.badge.checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            } else if status == .none {
                TextField("簡短說明你為什麼適合", text: $note, axis: .vertical)
                    .lineLimit(3...5)
                    .padding(12)
                    .background(JoinMeStyle.background, in: RoundedRectangle(cornerRadius: 8))

                Button {
                    store.apply(to: commission.id, note: note)
                    selectedTab = .review
                } label: {
                    Label("我想加入", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            } else {
                Label("申請已送出，發起人回覆後會更新狀態。", systemImage: "paperplane.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(JoinMeStyle.leaf)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    selectedTab = .review
                } label: {
                    Label("查看申請狀態", systemImage: "arrow.right.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct DetailRow: View {
    var symbolName: String
    var title: String
    var value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbolName)
                .font(.headline)
                .foregroundStyle(JoinMeStyle.leaf)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}
