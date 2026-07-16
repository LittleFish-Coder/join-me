import SwiftUI

struct CommissionDetailView: View {
    @Environment(JoinMeStore.self) private var store
    var commissionID: UUID
    @Binding var selectedTab: AppTab
    var onboarding: OnboardingGuideState?
    var onApplicationSubmitted: ((UUID) -> Void)?
    @State private var note = "我可以準時到，想用低壓方式一起完成這個委託。"

    private var commission: JoinCommission? {
        store.commission(id: commissionID)
    }

    private var status: JoinRequestStatus {
        store.applicationStatus(for: commissionID)
    }

    var body: some View {
        if let commission {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        titleBlock(commission)
                        hostBlock(commission.host)
                            .id(CommissionDetailScrollTarget.host)
                        keyFactsBlock(commission)
                            .id(CommissionDetailScrollTarget.keyFacts)
                        applyBlock(commission)
                            .id(CommissionDetailScrollTarget.apply)
                    }
                    .padding(16)
                    .padding(.bottom, 28)
                }
                .onChange(of: onboarding?.step, initial: true) { _, step in
                    scrollToOnboardingTarget(step, with: proxy)
                }
            }
            .background(JoinMeStyle.background)
            .navigationTitle("委託詳情")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView("找不到這張委託", systemImage: "doc.text.magnifyingglass")
        }
    }

    private func keyFactsBlock(_ commission: JoinCommission) -> some View {
        let isOnboardingTarget = onboarding?.step == .confirmDetails

        return VStack(alignment: .leading, spacing: 12) {
            detailRows(commission)
            descriptionBlock(commission)

            if isOnboardingTarget {
                OnboardingCallout(title: "時間、地點、相處方式都清楚")

                Button {
                    onboarding?.moveToApplication()
                } label: {
                    Label("帶我去加入", systemImage: "arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .overlay {
            if isOnboardingTarget {
                OnboardingTargetHalo(cornerRadius: 12)
            }
        }
    }

    private func titleBlock(_ commission: JoinCommission) -> some View {
        return VStack(alignment: .leading, spacing: 12) {
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
        let isOnboardingTarget = onboarding?.step == .apply

        return VStack(alignment: .leading, spacing: 12) {
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
                if onboarding?.showsScrollConfirmation == true {
                    Text("已幫你滑到這裡")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(JoinMeStyle.secondaryInk)
                }
                if isOnboardingTarget {
                    OnboardingCallout(title: "送出即可")
                }

                TextField("簡短說明你為什麼適合", text: $note, axis: .vertical)
                    .lineLimit(3...5)
                    .padding(12)
                    .background(JoinMeStyle.background, in: RoundedRectangle(cornerRadius: 8))

                Button {
                    guard store.applicationStatus(for: commission.id) == .none else { return }
                    store.apply(to: commission.id, note: note)
                    onApplicationSubmitted?(commission.id)
                    if onboarding != nil {
                        selectedTab = .review
                    }
                } label: {
                    Label("我想加入", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .overlay {
                    if isOnboardingTarget {
                        OnboardingTargetHalo(cornerRadius: 8)
                    }
                }
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

    private func scrollToOnboardingTarget(_ step: OnboardingStep?, with proxy: ScrollViewProxy) {
        guard let step else { return }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard onboarding?.step == step else { return }

            withAnimation(.smooth(duration: 0.55)) {
                switch step {
                case .confirmDetails:
                    proxy.scrollTo(CommissionDetailScrollTarget.host, anchor: .top)
                case .apply:
                    proxy.scrollTo(CommissionDetailScrollTarget.apply, anchor: .center)
                case .chooseLowPressure, .chooseCommission, .result:
                    break
                }
            }
        }
    }
}

private enum CommissionDetailScrollTarget: Hashable {
    case host
    case keyFacts
    case apply
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
