import SwiftUI

struct ChatListView: View {
    @EnvironmentObject private var store: JoinMeStore

    var body: some View {
        Group {
            if ProcessInfo.processInfo.arguments.contains("--chat-detail"),
               let firstChat = store.chats.first {
                ChatDetailView(chatID: firstChat.id)
            } else {
                List {
                    Section {
                        ForEach(store.chats) { chat in
                            NavigationLink {
                                ChatDetailView(chatID: chat.id)
                            } label: {
                                ChatRow(chat: chat)
                            }
                        }
                    } header: {
                        Text("活動專屬聊天室")
                    } footer: {
                        Text("每個聊天室只屬於一張委託，活動結束 24 小時後自動封存並保留紀錄。")
                    }
                }
                .scrollContentBackground(.hidden)
                .background(JoinMeStyle.background)
                .navigationTitle("聊天室")
            }
        }
    }
}

struct ChatRow: View {
    var chat: ActivityChat

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                BrandGradient()
                Image(systemName: chat.isArchived ? "archivebox.fill" : "bubble.left.and.bubble.right.fill")
                    .foregroundStyle(.white)
            }
            .frame(width: 46, height: 46)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(chat.messages.last?.body ?? "尚無訊息")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ChatDetailView: View {
    @EnvironmentObject private var store: JoinMeStore
    var chatID: UUID
    @State private var draft = ""

    private var chat: ActivityChat? {
        store.chats.first { $0.id == chatID }
    }

    var body: some View {
        if let chat {
            VStack(spacing: 0) {
                infoBanner(chat)

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(chat.messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(16)
                }

                composer(chat)
            }
            .background(JoinMeStyle.background)
            .navigationTitle(chat.title)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView("聊天室不存在", systemImage: "bubble.left.and.exclamationmark.bubble.right")
        }
    }

    private func infoBanner(_ chat: ActivityChat) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(chat.place, systemImage: "mappin.and.ellipse")
                Spacer()
                Text(chat.timeText)
            }
            .font(.caption.weight(.semibold))

            Label(chat.archiveText, systemImage: "archivebox")
                .font(.subheadline)
                .foregroundStyle(JoinMeStyle.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(.white)
        .overlay(alignment: .bottom) {
            Rectangle().fill(.black.opacity(0.06)).frame(height: 1)
        }
    }

    private func composer(_ chat: ActivityChat) -> some View {
        HStack(spacing: 10) {
            TextField(chat.isArchived ? "聊天室已封存" : "輸入訊息", text: $draft, axis: .vertical)
                .lineLimit(1...4)
                .padding(12)
                .background(.white, in: RoundedRectangle(cornerRadius: 8))
                .disabled(chat.isArchived)

            Button {
                store.sendMessage(draft, in: chat.id)
                draft = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.borderedProminent)
            .disabled(chat.isArchived || draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(12)
        .background(.ultraThinMaterial)
    }
}

struct MessageBubble: View {
    var message: ChatMessage

    var body: some View {
        HStack {
            if message.isMine { Spacer(minLength: 40) }

            VStack(alignment: message.isMine ? .trailing : .leading, spacing: 4) {
                Text(message.sender)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(message.body)
                    .font(.body)
                    .foregroundStyle(message.isMine ? .white : JoinMeStyle.ink)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(message.isMine ? JoinMeStyle.leaf : .white, in: RoundedRectangle(cornerRadius: 8))
                Text(message.timeText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if !message.isMine { Spacer(minLength: 40) }
        }
    }
}
