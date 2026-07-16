import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab
    @StateObject private var store = JoinMeStore()

    init() {
        _selectedTab = State(initialValue: AppTab.launchDefault)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ExploreView(selectedTab: $selectedTab)
            }
            .tabItem { Label(AppTab.explore.title, systemImage: AppTab.explore.symbolName) }
            .tag(AppTab.explore)

            NavigationStack {
                ReviewView(selectedTab: $selectedTab)
            }
            .tabItem { Label(AppTab.review.title, systemImage: AppTab.review.symbolName) }
            .tag(AppTab.review)

            NavigationStack {
                ChatListView()
            }
            .tabItem { Label(AppTab.chats.title, systemImage: AppTab.chats.symbolName) }
            .tag(AppTab.chats)

            NavigationStack {
                TrustView()
            }
            .tabItem { Label(AppTab.trust.title, systemImage: AppTab.trust.symbolName) }
            .tag(AppTab.trust)
        }
        .tint(JoinMeStyle.leaf)
        .environmentObject(store)
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
