import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class JoinMeStore {
    var commissions: [JoinCommission]
    var applications: [JoinApplication]
    var chats: [ActivityChat]
    var currentUser: UserProfile
    var completedActivities: [CompletedActivity]
    var reviews: [EventReview]

    init() {
        let me = UserProfile(
            name: "小羽",
            handle: "@merliah",
            avatar: "羽",
            age: 27,
            biologicalSex: .female,
            neighborhood: "台北大安",
            bio: "喜歡臨時揪咖啡、展覽和散步。希望先把事情完成，不急著變很熟。",
            pigeonIndex: 3,
            punctuality: 96,
            completedEvents: 18,
            tags: ["準時", "好溝通", "拍照友善"]
        )
        let aster = UserProfile(
            name: "阿哲",
            handle: "@aster",
            avatar: "哲",
            age: 29,
            biologicalSex: .male,
            neighborhood: "松山",
            bio: "下班後常在信義區出沒，偏好明確行程和輕鬆聊天。",
            pigeonIndex: 1,
            punctuality: 98,
            completedEvents: 34,
            tags: ["低壓", "可先不聊天"]
        )
        let nina = UserProfile(
            name: "Nina",
            handle: "@ninafilm",
            avatar: "妮",
            age: 25,
            biologicalSex: .female,
            neighborhood: "中山",
            bio: "底片、甜點、跑咖路線蒐集中。",
            pigeonIndex: 5,
            punctuality: 92,
            completedEvents: 21,
            tags: ["跑咖", "互拍", "不尷尬"]
        )
        let momo = UserProfile(
            name: "墨墨",
            handle: "@momoexpo",
            avatar: "墨",
            age: 23,
            biologicalSex: .undisclosed,
            neighborhood: "板橋",
            bio: "ACG、漫展和同好排隊互助。",
            pigeonIndex: 7,
            punctuality: 88,
            completedEvents: 12,
            tags: ["同好", "排隊OK"]
        )
        let kai = UserProfile(
            name: "凱",
            handle: "@kaikai",
            avatar: "凱",
            age: 31,
            biologicalSex: .male,
            neighborhood: "信義",
            bio: "演唱會前後找人一起吃點東西，行程清楚就好。",
            pigeonIndex: 2,
            punctuality: 97,
            completedEvents: 41,
            tags: ["演唱會", "路線熟"]
        )

        currentUser = me
        let milkTea = JoinCommission(
            title: "手搖飲買一送一缺一杯",
            area: "台北大安",
            place: "科技大樓站旁",
            timeText: "今天 16:20",
            participantText: "1 / 2 人",
            requirement: "不限性別，18+，可準時到店即可",
            type: .food,
            host: aster,
            summary: "臨時拿到買一送一券，想找附近的人分一杯。現場付款各半，不需要久聊，拿到飲料可各自解散。",
            tags: ["手搖飲", "低壓", "15分鐘"],
            accent: .teal,
            pinX: 0.54,
            pinY: 0.36,
            latitude: 25.0260,
            longitude: 121.5436
        )
        let cafePhoto = JoinCommission(
            title: "跑咖互拍一小時",
            area: "台北中山",
            place: "赤峰街",
            timeText: "今晚 19:00",
            participantText: "1 / 3 人",
            requirement: "20-35 歲，願意互拍 3-5 張即可",
            type: .cafe,
            host: me,
            summary: "想拍幾張新照片，也可以一起踩兩間咖啡店。重點是任務清楚，不走約會感。",
            tags: ["跑咖", "拍照", "女生友善"],
            accent: .orange,
            pinX: 0.49,
            pinY: 0.28,
            latitude: 25.0561,
            longitude: 121.5203,
            isHostedByCurrentUser: true
        )
        let expo = JoinCommission(
            title: "漫展同好排隊互相顧位",
            area: "台北南港",
            place: "南港展覽館",
            timeText: "週六 10:30",
            participantText: "2 / 4 人",
            requirement: "不限性別，ACG 同好，能接受排隊等待",
            type: .fandom,
            host: momo,
            summary: "主要是排隊、買周邊、互相提醒場次。不用整天綁定，分段行動也可以。",
            tags: ["漫展", "同好", "排隊"],
            accent: .purple,
            pinX: 0.72,
            pinY: 0.31,
            latitude: 25.0568,
            longitude: 121.6177
        )
        let concert = JoinCommission(
            title: "演唱會散場一起搭車",
            area: "台北信義",
            place: "台北大巨蛋",
            timeText: "週日 22:10",
            participantText: "1 / 2 人",
            requirement: "不限性別，散場後一起走到捷運或排計程車",
            type: .transit,
            host: kai,
            summary: "散場人很多，想找人一起走到捷運站或排車。只處理交通，不需要後續社交。",
            tags: ["演唱會", "交通", "安全感"],
            accent: .indigo,
            pinX: 0.63,
            pinY: 0.34,
            latitude: 25.0437,
            longitude: 121.5614
        )

        commissions = [milkTea, cafePhoto, expo, concert]
        applications = [
            JoinApplication(
                commissionID: cafePhoto.id,
                applicant: nina,
                note: "我有小相機，想互拍幾張自然一點的照片。19:00 可以準時到赤峰街。"
            ),
            JoinApplication(
                commissionID: cafePhoto.id,
                applicant: kai,
                note: "剛好在附近吃飯，可以幫忙拍照，也想順便找一家安靜咖啡店。"
            )
        ]
        chats = [
            ActivityChat(
                commissionID: concert.id,
                title: concert.title,
                place: concert.place,
                timeText: concert.timeText,
                archiveText: "活動結束後 24 小時自動封存，剩餘 23 小時 18 分",
                participants: [me, kai],
                messages: [
                    ChatMessage(sender: "凱", body: "我會在大巨蛋 2 號出口附近等。", timeText: "21:48", isMine: false),
                    ChatMessage(sender: "小羽", body: "好，我散場後看人流再跟你說。", timeText: "21:51", isMine: true)
                ]
            )
        ]

        let completedWalk = CompletedActivity(
            commissionID: milkTea.id,
            title: "下班後散步買飲料",
            participantIDs: [me.id, aster.id],
            completedAtText: "昨天 20:40"
        )
        completedActivities = [completedWalk]
        reviews = [
            EventReview(
                activityID: completedWalk.id,
                reviewerID: aster.id,
                revieweeID: me.id,
                punctuality: 5,
                communication: 5,
                completion: 4,
                comment: "時間與集合點都確認得很清楚。"
            )
        ]
    }

    var allTags: [String] {
        Array(Set(commissions.flatMap(\.tags))).sorted()
    }

    var reviewQueue: [JoinApplication] {
        applications
            .filter { application in
                guard let commission = commission(id: application.commissionID) else { return false }
                return commission.isHostedByCurrentUser && application.status == .pending
            }
    }

    var myHostedCommissions: [JoinCommission] {
        commissions.filter(\.isHostedByCurrentUser)
    }

    var myApplications: [JoinApplication] {
        applications.filter { $0.applicant.id == currentUser.id }
    }

    var pendingReviews: [PendingReview] {
        completedActivities.flatMap { activity in
            guard activity.participantIDs.contains(currentUser.id) else { return [PendingReview]() }

            return activity.participantIDs.compactMap { participantID in
                guard participantID != currentUser.id,
                      !reviews.contains(where: {
                          $0.activityID == activity.id
                              && $0.reviewerID == currentUser.id
                              && $0.revieweeID == participantID
                      }),
                      let participant = user(id: participantID) else {
                    return nil
                }
                return PendingReview(activity: activity, reviewee: participant)
            }
        }
    }

    func user(id: UUID) -> UserProfile? {
        if currentUser.id == id { return currentUser }
        return commissions.lazy.map(\.host).first { $0.id == id }
            ?? applications.lazy.map(\.applicant).first { $0.id == id }
            ?? chats.lazy.flatMap(\.participants).first { $0.id == id }
    }

    func userScore(for userID: UUID) -> Int? {
        let received = reviews.filter { $0.revieweeID == userID }
        guard !received.isEmpty else { return nil }
        return Int((Double(received.map(\.score).reduce(0, +)) / Double(received.count)).rounded())
    }

    func reviewCount(for userID: UUID) -> Int {
        reviews.count { $0.revieweeID == userID }
    }

    func submitReview(
        activityID: UUID,
        revieweeID: UUID,
        punctuality: Int,
        communication: Int,
        completion: Int,
        comment: String
    ) {
        guard completedActivities.contains(where: {
            $0.id == activityID
                && $0.participantIDs.contains(currentUser.id)
                && $0.participantIDs.contains(revieweeID)
        }), !reviews.contains(where: {
            $0.activityID == activityID
                && $0.reviewerID == currentUser.id
                && $0.revieweeID == revieweeID
        }) else { return }

        reviews.append(
            EventReview(
                activityID: activityID,
                reviewerID: currentUser.id,
                revieweeID: revieweeID,
                punctuality: min(max(punctuality, 1), 5),
                communication: min(max(communication, 1), 5),
                completion: min(max(completion, 1), 5),
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
    }

    func updateCurrentUser(
        name: String,
        handle: String,
        age: Int,
        biologicalSex: BiologicalSex,
        neighborhood: String,
        bio: String,
        tags: [String]
    ) {
        currentUser.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedHandle = handle.trimmingCharacters(in: .whitespacesAndNewlines)
        currentUser.handle = trimmedHandle.hasPrefix("@") ? trimmedHandle : "@\(trimmedHandle)"
        currentUser.age = min(max(age, 18), 100)
        currentUser.biologicalSex = biologicalSex
        currentUser.neighborhood = neighborhood.trimmingCharacters(in: .whitespacesAndNewlines)
        currentUser.bio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
        currentUser.tags = tags

        for index in commissions.indices where commissions[index].isHostedByCurrentUser {
            commissions[index].host = currentUser
        }
        for index in applications.indices where applications[index].applicant.id == currentUser.id {
            applications[index].applicant = currentUser
        }
        for chatIndex in chats.indices {
            for participantIndex in chats[chatIndex].participants.indices
                where chats[chatIndex].participants[participantIndex].id == currentUser.id {
                chats[chatIndex].participants[participantIndex] = currentUser
            }
        }
    }

    func commission(id: UUID) -> JoinCommission? {
        commissions.first { $0.id == id }
    }

    func applicationStatus(for commissionID: UUID) -> JoinRequestStatus {
        applications.first { $0.commissionID == commissionID && $0.applicant.id == currentUser.id }?.status ?? .none
    }

    func apply(to commissionID: UUID, note: String) {
        guard applicationStatus(for: commissionID) == .none else { return }
        applications.insert(
            JoinApplication(commissionID: commissionID, applicant: currentUser, note: note),
            at: 0
        )
    }

    func resetCurrentUserApplication(for commissionID: UUID) {
        applications.removeAll {
            $0.commissionID == commissionID && $0.applicant.id == currentUser.id
        }
    }

    func approve(applicationID: UUID) -> ActivityChat? {
        guard let index = applications.firstIndex(where: { $0.id == applicationID }),
              let commission = commission(id: applications[index].commissionID) else {
            return nil
        }

        applications[index].status = .accepted
        var chat = ActivityChat(
            commissionID: commission.id,
            title: commission.title,
            place: commission.place,
            timeText: commission.timeText,
            archiveText: "活動結束後 24 小時自動封存，剩餘 23 小時 56 分",
            participants: [commission.host, applications[index].applicant],
            messages: [
                ChatMessage(sender: "系統", body: "\(applications[index].applicant.name) 已錄取，這裡是活動專屬聊天室。", timeText: "現在", isMine: false),
                ChatMessage(sender: commission.host.name, body: "嗨！我們先把集合點和時間確認一下。", timeText: "現在", isMine: true)
            ]
        )

        if let existingIndex = chats.firstIndex(where: { $0.commissionID == commission.id }) {
            chats[existingIndex] = chat
            chat = chats[existingIndex]
        } else {
            chats.insert(chat, at: 0)
        }

        return chat
    }

    func sendMessage(_ body: String, in chatID: UUID) {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let index = chats.firstIndex(where: { $0.id == chatID }) else { return }
        chats[index].messages.append(ChatMessage(sender: currentUser.name, body: trimmed, timeText: "現在", isMine: true))
    }

    func updateHostedCommission(id: UUID, title: String, area: String, timeText: String, requirement: String, summary: String, tag: String) {
        guard let index = commissions.firstIndex(where: { $0.id == id && $0.isHostedByCurrentUser }) else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedArea = area.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTime = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedRequirement = requirement.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSummary = summary.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)

        commissions[index].title = trimmedTitle.isEmpty ? commissions[index].title : trimmedTitle
        commissions[index].area = trimmedArea.isEmpty ? commissions[index].area : trimmedArea
        commissions[index].place = trimmedArea.isEmpty ? commissions[index].place : trimmedArea
        commissions[index].timeText = trimmedTime.isEmpty ? commissions[index].timeText : trimmedTime
        commissions[index].requirement = trimmedRequirement.isEmpty ? commissions[index].requirement : trimmedRequirement
        commissions[index].summary = trimmedSummary.isEmpty ? commissions[index].summary : trimmedSummary

        if !trimmedTag.isEmpty {
            var tags = commissions[index].tags
            if tags.indices.contains(0) {
                tags[0] = trimmedTag
            } else {
                tags.append(trimmedTag)
            }
            commissions[index].tags = Array(NSOrderedSet(array: tags)) as? [String] ?? tags
        }
    }

    func createQuickCommission(title: String, area: String, timeText: String, tag: String, type: CommissionType, customTypeTitle: String) {
        let finalTimeText = timeText.isEmpty ? "今天稍晚" : timeText
        let isImmediate = JoinCommission.isImmediateStartText(finalTimeText)
        let finalType: CommissionType = isImmediate ? .immediate : type
        let trimmedCustomType = customTypeTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let customTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        let typeTag = finalType == .other && !trimmedCustomType.isEmpty ? trimmedCustomType : finalType.defaultTag
        let tags = Array(NSOrderedSet(array: [typeTag, customTag.isEmpty ? "低壓" : customTag, "新委託"])) as? [String] ?? [typeTag, "新委託"]
        let newCommission = JoinCommission(
            title: title.isEmpty ? "臨時附近走走" : title,
            area: area.isEmpty ? currentUser.neighborhood : area,
            place: area.isEmpty ? "附近集合點" : area,
            timeText: finalTimeText,
            participantText: "1 / 2 人",
            requirement: "不限性別，18+，行程清楚即可",
            type: finalType,
            customTypeTitle: finalType == .other ? trimmedCustomType : nil,
            host: currentUser,
            summary: "把集合方式與期待先說清楚，找到適合的人後就能在專屬聊天室確認細節。",
            tags: tags,
            accent: .mint,
            pinX: 0.56,
            pinY: 0.39,
            latitude: 25.0338,
            longitude: 121.5646,
            isHostedByCurrentUser: true
        )
        commissions.insert(newCommission, at: 0)
    }
}
