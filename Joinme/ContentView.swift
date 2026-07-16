import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab
    @State private var store = JoinMeStore()
    @State private var isShowingOnboarding: Bool
    @State private var onboardingState = OnboardingGuideState()
    @State private var exploreNavigationID = UUID()
    @State private var trustNavigationID = UUID()

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let startsOnboarding = arguments.contains("--onboarding")
            || (!arguments.contains("--skip-onboarding") && !arguments.contains("--start-tab"))

        _selectedTab = State(initialValue: startsOnboarding ? .explore : AppTab.launchDefault)
        _isShowingOnboarding = State(initialValue: startsOnboarding)
    }

    var body: some View {
        appTabs
            .overlay(alignment: .topTrailing) {
                if isShowingOnboarding, !onboardingState.showsWelcome {
                    OnboardingProgressPill(step: onboardingState.step)
                        .padding(.top, 8)
                        .padding(.trailing, 16)
                        .allowsHitTesting(false)
                }
            }
            .overlay {
                if isShowingOnboarding, onboardingState.showsWelcome {
                    OnboardingWelcomeView {
                        withAnimation(.smooth(duration: 0.45)) {
                            onboardingState.beginTutorial()
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 1.03)))
                    .zIndex(1)
                }
            }
        .tint(JoinMeStyle.leaf)
        .environment(store)
    }

    private var appTabs: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ExploreView(
                    selectedTab: $selectedTab,
                    onboarding: isShowingOnboarding ? onboardingState : nil,
                    onboardingCommissionID: milkTeaCommission?.id,
                    onLowPressureSelected: {
                        guard isShowingOnboarding, onboardingState.step == .chooseLowPressure else { return }
                        onboardingState.advance(to: .chooseCommission)
                    },
                    onCommissionOpened: { commissionID in
                        guard isShowingOnboarding,
                              onboardingState.step == .chooseCommission,
                              commissionID == milkTeaCommission?.id else { return }
                        onboardingState.advance(to: .confirmDetails)
                    }
                )
            }
            .id(exploreNavigationID)
            .tabItem { Label(AppTab.explore.title, systemImage: AppTab.explore.symbolName) }
            .tag(AppTab.explore)

            NavigationStack {
                ReviewView(
                    selectedTab: $selectedTab,
                    onboarding: isShowingOnboarding ? onboardingState : nil,
                    onboardingCommissionID: milkTeaCommission?.id,
                    finishOnboarding: finishOnboarding
                )
            }
            .tabItem { Label(AppTab.review.title, systemImage: AppTab.review.symbolName) }
            .tag(AppTab.review)

            NavigationStack {
                ChatListView()
            }
            .tabItem { Label(AppTab.chats.title, systemImage: AppTab.chats.symbolName) }
            .tag(AppTab.chats)

            NavigationStack {
                TrustView(replayOnboarding: replayOnboarding)
            }
            .id(trustNavigationID)
            .tabItem { Label(AppTab.trust.title, systemImage: AppTab.trust.symbolName) }
            .tag(AppTab.trust)
        }
    }

    private var milkTeaCommission: JoinCommission? {
        store.commissions.first { $0.tags.contains("手搖飲") }
    }

    private func finishOnboarding() {
        exploreNavigationID = UUID()
        selectedTab = .explore
        isShowingOnboarding = false
    }

    private func replayOnboarding() {
        if let commissionID = milkTeaCommission?.id {
            store.resetCurrentUserApplication(for: commissionID)
        }
        onboardingState.reset()
        exploreNavigationID = UUID()
        trustNavigationID = UUID()
        selectedTab = .explore
        isShowingOnboarding = true
    }
}

private extension AppTab {
    static var launchDefault: AppTab {
        let arguments = ProcessInfo.processInfo.arguments
        guard let flagIndex = arguments.firstIndex(of: "--start-tab"),
              arguments.indices.contains(arguments.index(after: flagIndex)) else {
            return .explore
        }

        return AppTab(rawValue: arguments[arguments.index(after: flagIndex)]) ?? .explore
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
