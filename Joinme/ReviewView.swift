import SwiftUI

struct ReviewView: View {
    @Environment(JoinMeStore.self) private var store
    @Binding var selectedTab: AppTab
    @State private var isPresentingComposer = ProcessInfo.processInfo.arguments.contains("--show-composer")
    @State private var myCommissionScope: MyCommissionScope = .hosted
    @State private var editingDraft: CommissionEditDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                reviewHero
                queueSection
                myCommissionsSection
            }
            .padding(16)
        }
        .background(JoinMeStyle.background)
        .navigationTitle("發起與審核")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingComposer = true
                } label: {
                    Label("發布", systemImage: "plus")
                }
                .accessibilityLabel("發布委託")
            }
        }
        .sheet(isPresented: $isPresentingComposer) {
            QuickCommissionSheet()
        }
        .sheet(item: $editingDraft) { draft in
            EditCommissionSheet(draft: draft)
        }
    }

    private var reviewHero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("委託管理", systemImage: "rectangle.stack.badge.person.crop")
                .font(.caption.weight(.bold))
                .foregroundStyle(JoinMeStyle.leaf)
            Text("審核誰可以加入")
                .font(.title2.weight(.bold))
            Text("查看申請者的基本資料與赴約紀錄；錄取後會立即建立活動聊天室。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }

    private var queueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("待審核申請", caption: "\(store.reviewQueue.count) 位等你回覆")

            if store.reviewQueue.isEmpty {
                ContentUnavailableView(
                    "目前沒有待審核",
                    systemImage: "checkmark.circle",
                    description: Text("發布委託後，新的申請會顯示在這裡。")
                )
                .padding(.vertical, 20)
                .background(.white, in: RoundedRectangle(cornerRadius: 8))
            } else {
                ForEach(store.reviewQueue) { application in
                    if let commission = store.commission(id: application.commissionID) {
                        ApplicationCard(application: application, commission: commission) {
                            _ = store.approve(applicationID: application.id)
                            selectedTab = .chats
                        }
                    }
                }
            }
        }
    }

    private var myCommissionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("我的委託", caption: "查看目前發布或申請中的委託。")

            Picker("我的委託", selection: $myCommissionScope) {
                ForEach(MyCommissionScope.allCases) { scope in
                    Text(scope.title).tag(scope)
                }
            }
            .pickerStyle(.segmented)

            switch myCommissionScope {
            case .hosted:
                if store.myHostedCommissions.isEmpty {
                    ContentUnavailableView(
                        "尚未發布委託",
                        systemImage: "megaphone",
                        description: Text("按右上角加號發布第一張委託。")
                    )
                    .padding(.vertical, 20)
                    .background(.white, in: RoundedRectangle(cornerRadius: 8))
                } else {
                    ForEach(store.myHostedCommissions) { commission in
                        HostedCommissionManagementCard(commission: commission) {
                            editingDraft = CommissionEditDraft(commission: commission)
                        }
                    }
                }
            case .applied:
                if store.myApplications.isEmpty {
                    ContentUnavailableView(
                        "尚未申請委託",
                        systemImage: "paperplane",
                        description: Text("從探索頁找到想加入的委託後，申請狀態會出現在這裡。")
                    )
                    .padding(.vertical, 20)
                    .background(.white, in: RoundedRectangle(cornerRadius: 8))
                } else {
                    ForEach(store.myApplications) { application in
                        if let commission = store.commission(id: application.commissionID) {
                            AppliedCommissionCard(application: application, commission: commission)
                        }
                    }
                }
            }
        }
    }
}

private enum MyCommissionScope: String, CaseIterable, Identifiable {
    case hosted
    case applied

    var id: String { rawValue }

    var title: String {
        switch self {
        case .hosted: "我發布的"
        case .applied: "我申請的"
        }
    }
}

struct HostedCommissionManagementCard: View {
    var commission: JoinCommission
    var edit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: commission.typeSymbolName)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(commission.accent, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 5) {
                    Text(commission.typeTitle)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(commission.accent)
                    Text(commission.title)
                        .font(.headline)
                        .foregroundStyle(JoinMeStyle.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(commission.area) · \(commission.place)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack(spacing: 8) {
                MetricPill(symbolName: "clock", text: commission.timeText)
                MetricPill(symbolName: "person.2", text: commission.participantText)
            }

            HStack(spacing: 8) {
                MetricPill(symbolName: "person.crop.circle.badge.checkmark", text: "可審核申請")
                MetricPill(symbolName: "pencil.and.list.clipboard", text: "可修改細節")
            }

            Button {
                edit()
            } label: {
                Label("編輯細節", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black.opacity(0.06))
        }
    }
}

struct AppliedCommissionCard: View {
    var application: JoinApplication
    var commission: JoinCommission

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: statusSymbolName)
                    .font(.headline)
                    .foregroundStyle(statusColor)
                    .frame(width: 40, height: 40)
                    .background(statusColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text(commission.title)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(commission.area) · \(commission.timeText)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("狀態：\(application.status.label)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(statusColor)
                }
                Spacer()
            }

            Text(application.note)
                .font(.subheadline)
                .foregroundStyle(JoinMeStyle.ink)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                AvatarBadge(profile: commission.host, size: 34)
                Text("發起人 \(commission.host.name)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black.opacity(0.06))
        }
    }

    private var statusSymbolName: String {
        switch application.status {
        case .none: "paperplane"
        case .pending: "hourglass"
        case .accepted: "checkmark.message.fill"
        case .declined: "xmark.circle"
        }
    }

    private var statusColor: Color {
        switch application.status {
        case .none, .pending: JoinMeStyle.sun
        case .accepted: JoinMeStyle.leaf
        case .declined: JoinMeStyle.coral
        }
    }
}

struct CommissionEditDraft: Identifiable {
    let id: UUID
    var title: String
    var area: String
    var timeText: String
    var requirement: String
    var summary: String
    var tag: String

    init(commission: JoinCommission) {
        id = commission.id
        title = commission.title
        area = commission.area
        timeText = commission.timeText
        requirement = commission.requirement
        summary = commission.summary
        tag = commission.tags.first ?? commission.typeTitle
    }
}

struct EditCommissionSheet: View {
    @Environment(JoinMeStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var draft: CommissionEditDraft

    init(draft: CommissionEditDraft) {
        _draft = State(initialValue: draft)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("可修改細節") {
                    TextField("活動名稱", text: $draft.title)
                    TextField("地區", text: $draft.area)
                    TextField("時間", text: $draft.timeText)
                    TextField("主要標籤", text: $draft.tag)
                    TextField("條件", text: $draft.requirement, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("委託說明", text: $draft.summary, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    Text("為了避免申請者資訊落差，這裡只開放修改文字細節；委託類型、人數與發起人身分會保持不變。")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("編輯委託")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
                        store.updateHostedCommission(
                            id: draft.id,
                            title: draft.title,
                            area: draft.area,
                            timeText: draft.timeText,
                            requirement: draft.requirement,
                            summary: draft.summary,
                            tag: draft.tag
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ApplicationCard: View {
    var application: JoinApplication
    var commission: JoinCommission
    var approve: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                AvatarBadge(profile: application.applicant, size: 54)
                VStack(alignment: .leading, spacing: 4) {
                    Text(application.applicant.name)
                        .font(.headline)
                    Text("\(application.applicant.age) 歲 · \(application.applicant.neighborhood)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("申請：\(commission.title)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(JoinMeStyle.leaf)
                }
                Spacer()
            }

            Text(application.note)
                .font(.subheadline)
                .foregroundStyle(JoinMeStyle.ink)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                MetricPill(symbolName: "exclamationmark.triangle", text: "鴿子 \(application.applicant.pigeonIndex)")
                MetricPill(symbolName: "timer", text: "\(application.applicant.punctuality)% 準時")
                MetricPill(symbolName: "checkmark.circle", text: "\(application.applicant.completedEvents) 場")
            }

            HStack {
                Button {
                } label: {
                    Label("稍後", systemImage: "clock")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    approve()
                } label: {
                    Label("錄取開聊", systemImage: "checkmark.message.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black.opacity(0.06))
        }
    }
}

struct QuickCommissionSheet: View {
    @Environment(JoinMeStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var title = "下班後一起走信義散步路線"
    @State private var area = "台北信義"
    @State private var timeText = "今天 20:30"
    @State private var tag = "散步"
    @State private var type: CommissionType = .walk
    @State private var customTypeTitle = ""

    private var isImmediatePreview: Bool {
        JoinCommission.isImmediateStartText(timeText.isEmpty ? "今天稍晚" : timeText)
    }

    private var previewType: CommissionType {
        isImmediatePreview ? .immediate : type
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("委託類型") {
                    Picker("委託類型", selection: $type) {
                        ForEach(CommissionType.selectableCases) { type in
                            Label(type.title, systemImage: type.symbolName)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)

                    if type.isUserCustomizable && !isImmediatePreview {
                        TextField("自訂類型名稱，例如：讀書、桌遊、代排", text: $customTypeTitle)
                    }

                    TypePreviewCard(
                        type: previewType,
                        customTypeTitle: customTypeTitle,
                        isImmediate: isImmediatePreview
                    )
                }

                Section("快速委託單") {
                    TextField("活動名稱", text: $title)
                    TextField("地區", text: $area)
                    TextField("時間", text: $timeText)
                    TextField("標籤", text: $tag)
                }

                Section {
                    Text("發布前請確認時間、地點與活動目的，讓加入的人能快速判斷是否適合。")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("發布委託")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("發布") {
                        store.createQuickCommission(
                            title: title,
                            area: area,
                            timeText: timeText,
                            tag: tag,
                            type: type,
                            customTypeTitle: customTypeTitle
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TypePreviewCard: View {
    var type: CommissionType
    var customTypeTitle: String
    var isImmediate: Bool

    private var title: String {
        if type == .other {
            let trimmed = customTypeTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? type.title : trimmed
        }

        return type.title
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.symbolName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(JoinMeStyle.leaf, in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(isImmediate ? "開始時間在發布後 24 小時內，系統會自動歸類為立即委託。" : "發布後會用這個類型標示委託，也可作為地圖 pin 與篩選依據。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}
