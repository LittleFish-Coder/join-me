import SwiftUI

struct TrustView: View {
    @Environment(JoinMeStore.self) private var store
    @State private var selectedReview: PendingReview?
    @State private var isEditingProfile = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                profileOverview
                reviewSection
                supportSection
            }
            .padding(16)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(JoinMeStyle.background)
        .navigationTitle("個人")
        .sheet(isPresented: $isEditingProfile) {
            EditProfileSheet(profile: store.currentUser)
        }
        .sheet(item: $selectedReview) { review in
            EventReviewSheet(pendingReview: review)
        }
    }

    private var profileOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                AvatarBadge(profile: store.currentUser, size: 62)
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.currentUser.name)
                        .font(.title3.weight(.bold))
                    Text("\(store.currentUser.handle) · \(store.currentUser.biologicalSex.rawValue) · \(store.currentUser.age) 歲")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(store.currentUser.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                Button {
                    isEditingProfile = true
                } label: {
                    Image(systemName: "pencil")
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("編輯個人資料")
            }

            HStack(spacing: 10) {
                ScoreBox(
                    title: "用戶分數",
                    value: store.userScore(for: store.currentUser.id).map(String.init) ?? "—",
                    caption: "來自 \(store.reviewCount(for: store.currentUser.id)) 筆互評"
                )
                ScoreBox(
                    title: "完成紀錄",
                    value: "\(store.currentUser.completedEvents)",
                    caption: "準時度 \(store.currentUser.punctuality)%"
                )
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

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("活動後互評", caption: "雙方分開評分，送出後會更新對方的用戶分數。")

            if store.pendingReviews.isEmpty {
                ContentUnavailableView(
                    "互評已完成",
                    systemImage: "checkmark.seal",
                    description: Text("活動結束後，待評價的同行者會顯示在這裡。")
                )
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.white, in: RoundedRectangle(cornerRadius: 8))
            } else {
                ForEach(store.pendingReviews) { pending in
                    Button {
                        selectedReview = pending
                    } label: {
                        HStack(spacing: 12) {
                            AvatarBadge(profile: pending.reviewee, size: 48)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(pending.activity.title)
                                    .font(.headline)
                                    .foregroundStyle(JoinMeStyle.ink)
                                Text("評價 \(pending.reviewee.name) · \(pending.activity.completedAtText)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(.white, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("使用協助")

            NavigationLink {
                OnboardingGuideView()
            } label: {
                SupportRow(symbolName: "sparkles", title: "新手教學", caption: "從找委託到活動後互評")
            }
            .buttonStyle(.plain)

            NavigationLink {
                FAQView()
            } label: {
                SupportRow(symbolName: "questionmark.bubble", title: "常見問題", caption: "委託、審核、聊天室與安全")
            }
            .buttonStyle(.plain)
        }
    }
}

struct EditProfileSheet: View {
    @Environment(JoinMeStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var handle: String
    @State private var age: Int
    @State private var biologicalSex: BiologicalSex
    @State private var neighborhood: String
    @State private var bio: String
    @State private var tagsText: String

    init(profile: UserProfile) {
        _name = State(initialValue: profile.name)
        _handle = State(initialValue: profile.handle)
        _age = State(initialValue: profile.age)
        _biologicalSex = State(initialValue: profile.biologicalSex)
        _neighborhood = State(initialValue: profile.neighborhood)
        _bio = State(initialValue: profile.bio)
        _tagsText = State(initialValue: profile.tags.joined(separator: "、"))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("帳號") {
                    TextField("顯示名稱", text: $name)
                    TextField("帳號", text: $handle)
                        .textInputAutocapitalization(.never)
                    Stepper("年齡：\(age)", value: $age, in: 18...100)
                    Picker("生理性別", selection: $biologicalSex) {
                        ForEach(BiologicalSex.allCases) { sex in
                            Text(sex.rawValue).tag(sex)
                        }
                    }
                }

                Section("自我介紹") {
                    TextField("常出沒地區", text: $neighborhood)
                    TextField("簡介", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("標籤，以頓號分隔", text: $tagsText)
                }
            }
            .navigationTitle("編輯個人資料")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
                        let tags = tagsText
                            .split(whereSeparator: { $0 == "、" || $0 == "," })
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }
                        store.updateCurrentUser(
                            name: name,
                            handle: handle,
                            age: age,
                            biologicalSex: biologicalSex,
                            neighborhood: neighborhood,
                            bio: bio,
                            tags: tags
                        )
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct EventReviewSheet: View {
    @Environment(JoinMeStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    var pendingReview: PendingReview
    @State private var punctuality = 5
    @State private var communication = 5
    @State private var completion = 5
    @State private var comment = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 12) {
                        AvatarBadge(profile: pendingReview.reviewee, size: 52)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(pendingReview.reviewee.name)
                                .font(.headline)
                            Text(pendingReview.activity.title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("評分") {
                    RatingPicker(title: "準時", value: $punctuality)
                    RatingPicker(title: "溝通", value: $communication)
                    RatingPicker(title: "完成委託", value: $completion)
                }

                Section("補充（選填）") {
                    TextField("留下簡短回饋", text: $comment, axis: .vertical)
                        .lineLimit(2...5)
                }

                Section {
                    HStack {
                        Text("本次量化分數")
                        Spacer()
                        Text("\(calculatedScore)")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(JoinMeStyle.leaf)
                    }
                } footer: {
                    Text("三項分數等權換算為 0–100 分，對方的用戶分數為收到評價的平均值。")
                }
            }
            .navigationTitle("活動互評")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("送出") {
                        store.submitReview(
                            activityID: pendingReview.activity.id,
                            revieweeID: pendingReview.reviewee.id,
                            punctuality: punctuality,
                            communication: communication,
                            completion: completion,
                            comment: comment
                        )
                        dismiss()
                    }
                }
            }
        }
    }

    private var calculatedScore: Int {
        Int((Double(punctuality + communication + completion) / 15 * 100).rounded())
    }
}

struct RatingPicker: View {
    var title: String
    @Binding var value: Int

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HStack(spacing: 6) {
                ForEach(1...5, id: \.self) { score in
                    Button {
                        value = score
                    } label: {
                        Image(systemName: score <= value ? "star.fill" : "star")
                            .foregroundStyle(score <= value ? JoinMeStyle.sun : .secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(score) 分")
                }
            }
        }
    }
}

struct OnboardingGuideView: View {
    private let steps = [
        ("1", "探索附近委託", "依時間、地點與類型篩選，找到適合的同行需求。", "sparkle.magnifyingglass"),
        ("2", "送出申請", "簡短說明你能配合的方式，等待發起人審核。", "paperplane.fill"),
        ("3", "確認活動細節", "錄取後在專屬聊天室確認集合點與時間。", "bubble.left.and.bubble.right.fill"),
        ("4", "完成後互評", "雙方針對準時、溝通與完成度評分。", "checkmark.seal.fill")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                JoinMeWordmark()
                    .padding(.bottom, 4)
                ForEach(steps, id: \.0) { step in
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: step.3)
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(JoinMeStyle.leaf, in: RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(step.1)
                                .font(.headline)
                            Text(step.2)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(14)
                    .background(.white, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(16)
        }
        .background(JoinMeStyle.background)
        .navigationTitle("新手教學")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQView: View {
    private let items = [
        ("我可以看到自己發布的委託嗎？", "探索頁與地圖不會顯示自己發布的委託；請到「審核」查看與編輯。"),
        ("錄取後要怎麼聯絡？", "錄取時會建立該活動專屬聊天室，雙方可在裡面確認集合資訊。"),
        ("用戶分數怎麼計算？", "每次活動的準時、溝通與完成度各為 1–5 分，等權換算成 0–100 分後取平均。"),
        ("可以修改個人資料嗎？", "可以。在「個人」頁點右上方鉛筆，即可修改帳號、年齡、生理性別、地區與簡介。")
    ]

    var body: some View {
        List {
            ForEach(items, id: \.0) { item in
                DisclosureGroup(item.0) {
                    Text(item.1)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 8)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(JoinMeStyle.background)
        .navigationTitle("常見問題")
    }
}

struct SupportRow: View {
    var symbolName: String
    var title: String
    var caption: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbolName)
                .font(.headline)
                .foregroundStyle(JoinMeStyle.leaf)
                .frame(width: 38, height: 38)
                .background(JoinMeStyle.leaf.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(JoinMeStyle.ink)
                Text(caption)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
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
