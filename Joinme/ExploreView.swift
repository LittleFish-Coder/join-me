import MapKit
import SwiftUI

struct ExploreView: View {
    @Environment(JoinMeStore.self) private var store
    @Binding var selectedTab: AppTab
    @State private var query = ""
    @State private var selectedTag: String?
    @State private var mode: ExploreMode

    init(selectedTab: Binding<AppTab>) {
        _selectedTab = selectedTab
        _mode = State(initialValue: ProcessInfo.processInfo.arguments.contains("--map-mode") ? .map : .nearby)
    }

    private enum ExploreMode: String, CaseIterable, Identifiable {
        case nearby = "附近"
        case map = "地圖"

        var id: String { rawValue }
    }

    private var filteredCommissions: [JoinCommission] {
        store.commissions.filter { commission in
            let matchesQuery = query.isEmpty
                || commission.title.localizedStandardContains(query)
                || commission.area.localizedStandardContains(query)
                || commission.tags.contains { $0.localizedStandardContains(query) }
            let matchesTag = selectedTag == nil || commission.tags.contains(selectedTag!)
            return !commission.isHostedByCurrentUser && matchesQuery && matchesTag
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                JoinMeWordmark()
                hero
                searchControls

                if mode == .map {
                    MapKitCommissionMapView(commissions: filteredCommissions)
                }

                SectionHeader("附近委託", caption: "先看時間、地點與目的，找到剛好能同行的人。")

                LazyVStack(spacing: 12) {
                    ForEach(filteredCommissions) { commission in
                        NavigationLink {
                            CommissionDetailView(commissionID: commission.id, selectedTab: $selectedTab)
                        } label: {
                            CommissionCard(commission: commission)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(JoinMeStyle.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("想做的事，現在就找人同行")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    Text("把目的、時間與地點說清楚，輕鬆找到剛好有空的人。")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.88))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 12)
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.18))
                    Image(systemName: "link")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 58, height: 58)
            }

            HStack {
                MetricPill(symbolName: "location.fill", text: "台北附近")
                MetricPill(symbolName: "clock.fill", text: "隨時可以出發")
            }
        }
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [JoinMeStyle.leaf, JoinMeStyle.coral, JoinMeStyle.sun],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }

    private var searchControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("探索模式", selection: $mode) {
                ForEach(ExploreMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("搜尋手搖飲、跑咖、演唱會", text: $query)
                    .textInputAutocapitalization(.never)
            }
            .padding(12)
            .background(.white, in: RoundedRectangle(cornerRadius: 8))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button {
                        selectedTag = nil
                    } label: {
                        JMTag(text: "全部", isSelected: selectedTag == nil)
                    }
                    .buttonStyle(.plain)

                    ForEach(store.allTags, id: \.self) { tag in
                        Button {
                            selectedTag = tag
                        } label: {
                            JMTag(text: tag, isSelected: selectedTag == tag)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct CommissionCard: View {
    var commission: JoinCommission

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Label(commission.typeTitle, systemImage: commission.typeSymbolName)
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
                Image(systemName: commission.isHostedByCurrentUser ? "megaphone.fill" : commission.typeSymbolName)
                    .font(.headline)
                    .foregroundStyle(commission.accent)
            }

            HStack(spacing: 8) {
                MetricPill(symbolName: "clock", text: commission.timeText)
                MetricPill(symbolName: "person.2", text: commission.participantText)
            }

            HStack(spacing: 8) {
                AvatarBadge(profile: commission.host, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(commission.host.name)
                        .font(.subheadline.weight(.semibold))
                    Text("鴿子指數 \(commission.host.pigeonIndex) · 準時度 \(commission.host.punctuality)%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(commission.tags, id: \.self) { tag in
                        JMTag(text: tag)
                    }
                }
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

struct MapKitCommissionMapView: View {
    var commissions: [JoinCommission]
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.0478, longitude: 121.5319),
            span: MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.155)
        )
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                Map(position: $cameraPosition) {
                    ForEach(commissions) { commission in
                        Annotation(commission.title, coordinate: commission.coordinate) {
                            VStack(spacing: 4) {
                                Image(systemName: "figure.2.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white, commission.accent)
                                    .shadow(color: .black.opacity(0.22), radius: 5, y: 2)
                                Text(commission.area.replacingOccurrences(of: "台北", with: ""))
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(JoinMeStyle.ink)
                                    .lineLimit(1)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 4)
                                    .background(.white, in: Capsule())
                                    .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Label("附近委託", systemImage: "map.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(JoinMeStyle.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(.regularMaterial, in: Capsule())
                    .padding(10)
            }

            HStack(spacing: 8) {
                MetricPill(symbolName: "scope", text: "共 \(commissions.count) 張委託")
            }
        }
        .padding(10)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black.opacity(0.06))
        }
    }
}
