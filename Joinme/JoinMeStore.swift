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
        let eddie = UserProfile(
            name: "Eddie",
            handle: "@eddiehoops",
            avatar: "E",
            age: 28,
            biologicalSex: .male,
            neighborhood: "台北大安",
            bio: "下班後打籃球、慢跑和重量訓練，喜歡先講好強度再一起動。",
            pigeonIndex: 2,
            punctuality: 97,
            completedEvents: 29,
            tags: ["籃球", "健身", "配合強度"]
        )
        let fish = UserProfile(
            name: "Fish",
            handle: "@fishcareer",
            avatar: "魚",
            age: 26,
            biologicalSex: .undisclosed,
            neighborhood: "台北松山",
            bio: "對職涯與求職有點焦慮，希望透過 Coffee Chat 認識不同職位的學長姐。",
            pigeonIndex: 3,
            punctuality: 95,
            completedEvents: 16,
            tags: ["Coffee Chat", "科技業", "職涯交流"]
        )
        let leo = UserProfile(
            name: "Leo",
            handle: "@leobeats",
            avatar: "L",
            age: 27,
            biologicalSex: .male,
            neighborhood: "台北中正",
            bio: "用 FL Studio 做電子音樂，也喜歡找人 Jam 和交換製作方法。",
            pigeonIndex: 4,
            punctuality: 94,
            completedEvents: 24,
            tags: ["FL Studio", "編曲", "Jam"]
        )
        let zoe = UserProfile(
            name: "Zoe",
            handle: "@zoeweekend",
            avatar: "Z",
            age: 26,
            biologicalSex: .female,
            neighborhood: "台北中山",
            bio: "週末喜歡找新餐廳、散步和看城市夜景。",
            pigeonIndex: 2,
            punctuality: 97,
            completedEvents: 31,
            tags: ["好溝通", "行程清楚", "低壓"]
        )
        let sean = UserProfile(
            name: "Sean",
            handle: "@seanmoves",
            avatar: "S",
            age: 30,
            biologicalSex: .male,
            neighborhood: "新北板橋",
            bio: "常往返台北與桃園，也樂意揪人處理生活裡需要搭把手的事。",
            pigeonIndex: 1,
            punctuality: 99,
            completedEvents: 38,
            tags: ["交通熟", "生活互助", "準時"]
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
        let nightMarket = JoinCommission(
            title: "寧夏夜市分食小隊",
            area: "台北大同",
            place: "寧夏夜市入口",
            timeText: "8/2 18:30",
            participantText: "2 / 4 人",
            requirement: "不限性別，願意一起分食 3–4 攤",
            type: .food,
            host: zoe,
            summary: "想多吃幾樣又不想每份都吃完，集合後一起選攤位、分食並平均分攤費用。",
            tags: ["吃喝", "夜市", "分食"],
            accent: .orange,
            pinX: 0.46,
            pinY: 0.25,
            latitude: 25.0561,
            longitude: 121.5150
        )
        let brunch = JoinCommission(
            title: "週末早午餐新店踩點",
            area: "台北松山",
            place: "民生社區富錦街",
            timeText: "8/9 11:00",
            participantText: "1 / 3 人",
            requirement: "不限性別，不趕行程即可",
            type: .food,
            host: aster,
            summary: "收藏了一家新開的早午餐，想找一兩位一起點不同餐交換吃，不需要續攤。",
            tags: ["吃喝", "早午餐", "低壓"],
            accent: .yellow,
            pinX: 0.61,
            pinY: 0.27,
            latitude: 25.0601,
            longitude: 121.5587
        )
        let oldHouseCafe = JoinCommission(
            title: "大稻埕老宅咖啡互拍",
            area: "台北大同",
            place: "迪化街一段",
            timeText: "8/1 14:30",
            participantText: "1 / 3 人",
            requirement: "願意互拍，手機或相機都可以",
            type: .cafe,
            host: nina,
            summary: "想踩一間老宅咖啡，也想在附近街景互拍幾張自然照片，成片會互傳。",
            tags: ["跑咖", "互拍", "老宅"],
            accent: .brown,
            pinX: 0.43,
            pinY: 0.23,
            latitude: 25.0576,
            longitude: 121.5094
        )
        let dessertPhoto = JoinCommission(
            title: "公館甜點店新品互拍",
            area: "台北中正",
            place: "公館商圈水源市場旁",
            timeText: "8/13 15:00",
            participantText: "2 / 4 人",
            requirement: "不限性別，接受輪流拍照",
            type: .cafe,
            host: zoe,
            summary: "想試新品甜點，也希望大家幫彼此拍幾張。會先確認想要的構圖，不用擔心尷尬。",
            tags: ["跑咖", "甜點", "拍照"],
            accent: .pink,
            pinX: 0.50,
            pinY: 0.52,
            latitude: 25.0147,
            longitude: 121.5342
        )
        let animationPremiere = JoinCommission(
            title: "動畫電影首映同好場",
            area: "台北信義",
            place: "信義威秀影城",
            timeText: "8/6 19:20",
            participantText: "2 / 5 人",
            requirement: "看過前作，散場後可聊 30 分鐘",
            type: .fandom,
            host: momo,
            summary: "想和同好一起看首映，開演前各自取票，散場後再找地方聊劇情與彩蛋。",
            tags: ["同好", "動畫", "電影"],
            accent: .purple,
            pinX: 0.64,
            pinY: 0.36,
            latitude: 25.0357,
            longitude: 121.5670
        )
        let pokemonCards = JoinCommission(
            title: "寶可夢卡牌新手交流",
            area: "台北萬華",
            place: "西門町卡牌店",
            timeText: "8/16 13:30",
            participantText: "3 / 6 人",
            requirement: "新手友善，自備牌組或現場借用",
            type: .fandom,
            host: momo,
            summary: "以規則教學與輕鬆對戰為主，不比稀有卡，也不強迫交換卡片。",
            tags: ["同好", "寶可夢", "新手友善"],
            accent: .indigo,
            pinX: 0.44,
            pinY: 0.38,
            latitude: 25.0438,
            longitude: 121.5077
        )
        let flMusic = JoinCommission(
            title: "ＦＬ音樂製作請教",
            area: "台北南港",
            place: "台北流行音樂中心 共創空間",
            timeText: "8/7 19:30",
            participantText: "1 / 4 人",
            requirement: "不限性別，有作品片段或問題清單即可",
            type: .music,
            host: leo,
            summary: "剛開始用 FL Studio 做歌，想請教編曲、混音與工作流程。會帶筆電和耳機，也可以互相分享作品。",
            tags: ["音樂", "FL Studio", "編曲"],
            accent: .cyan,
            pinX: 0.75,
            pinY: 0.28,
            latitude: 25.0541,
            longitude: 121.6178
        )
        let acousticJam = JoinCommission(
            title: "週末不插電 Jam 缺吉他手",
            area: "台北中正",
            place: "公館共享排練室",
            timeText: "8/10 15:00",
            participantText: "3 / 5 人",
            requirement: "能跟基本和弦，曲目現場一起決定",
            type: .music,
            host: leo,
            summary: "目前有主唱、木箱鼓和鍵盤，想找吉他手一起輕鬆 Jam 兩小時，不以演出為目的。",
            tags: ["音樂", "Jam", "吉他"],
            accent: .mint,
            pinX: 0.51,
            pinY: 0.50,
            latitude: 25.0152,
            longitude: 121.5334
        )
        let basketball = JoinCommission(
            title: "想找人在大安森林公園單挑籃球",
            area: "台北大安",
            place: "大安森林公園籃球場",
            timeText: "8/3 18:30",
            participantText: "1 / 2 人",
            requirement: "不限性別與程度",
            type: .fitness,
            host: eddie,
            summary: "想找人輕鬆單挑籃球，先熱身再打幾局，強度可以現場討論，不會打滿也沒關係。",
            tags: ["健身", "籃球", "不限程度"],
            accent: .blue,
            pinX: 0.53,
            pinY: 0.43,
            latitude: 25.0324,
            longitude: 121.5361
        )
        let riverRun = JoinCommission(
            title: "下班後河濱 5K 慢跑",
            area: "台北中山",
            place: "大佳河濱公園入口",
            timeText: "8/12 19:00",
            participantText: "2 / 6 人",
            requirement: "配速約 7–8 分，可跑走交替",
            type: .fitness,
            host: eddie,
            summary: "從大佳河濱出發跑 5K，途中會停一次補水，重點是一起完成而不是拚速度。",
            tags: ["健身", "慢跑", "下班後"],
            accent: .green,
            pinX: 0.57,
            pinY: 0.20,
            latitude: 25.0734,
            longitude: 121.5358
        )
        let coffeeChat = JoinCommission(
            title: "想找學長姐 Coffee Chat",
            area: "台北松山",
            place: "SkyCo 南京復興 9F",
            timeText: "8/15 14:00",
            participantText: "7 / 100 人",
            requirement: "不限性別",
            type: .career,
            host: fish,
            summary: """
            最近一直在 SWE 和 Solution Engineer 之間來回思考。喜歡寫程式、把系統做深，也享受理解客戶需求、把技術方案說清楚，但還不確定哪一種工作節奏更適合自己。

            想找做過 SWE 或 Solution Engineer 的學長姐 Coffee Chat，聊聊兩種角色的日常、能力要求、面試準備與職涯發展，希望能更具體地做出選擇。
            """,
            tags: ["職涯", "Coffee Chat", "科技業"],
            accent: .indigo,
            pinX: 0.58,
            pinY: 0.30,
            latitude: 25.0522,
            longitude: 121.5445
        )
        let resumePractice = JoinCommission(
            title: "履歷互看與模擬面試",
            area: "台北松山",
            place: "南京復興站附近共享空間",
            timeText: "8/22 19:00",
            participantText: "3 / 8 人",
            requirement: "不限性別，自備一頁履歷",
            type: .career,
            host: fish,
            summary: "最近準備求職有點焦慮，想找同樣在轉職或找實習的人互看履歷，再輪流練習自我介紹。",
            tags: ["職涯", "履歷", "模擬面試"],
            accent: .teal,
            pinX: 0.58,
            pinY: 0.30,
            latitude: 25.0520,
            longitude: 121.5439
        )
        let elephantMountainWalk = JoinCommission(
            title: "象山夕陽輕鬆走",
            area: "台北信義",
            place: "象山公園入口",
            timeText: "8/8 17:20",
            participantText: "2 / 5 人",
            requirement: "能走階梯，途中可隨時休息",
            type: .walk,
            host: zoe,
            summary: "慢慢走到觀景台看夕陽，不趕攻頂，沿途想停下拍照也可以。",
            tags: ["散步", "夕陽", "輕量健行"],
            accent: .orange,
            pinX: 0.70,
            pinY: 0.45,
            latitude: 25.0270,
            longitude: 121.5717
        )
        let riversideWalk = JoinCommission(
            title: "大稻埕河岸散步拍夜景",
            area: "台北大同",
            place: "大稻埕碼頭五號水門",
            timeText: "8/18 19:10",
            participantText: "1 / 4 人",
            requirement: "不限性別，步調輕鬆",
            type: .walk,
            host: nina,
            summary: "從碼頭沿河走到延平河濱公園，想拍夜景可以停，預計一小時左右結束。",
            tags: ["散步", "夜景", "拍照"],
            accent: .purple,
            pinX: 0.39,
            pinY: 0.31,
            latitude: 25.0566,
            longitude: 121.5075
        )
        let airportRide = JoinCommission(
            title: "桃園機場共乘分車資",
            area: "台北中正",
            place: "台北車站東三門",
            timeText: "8/20 06:10",
            participantText: "1 / 4 人",
            requirement: "第二航廈，行李一大一小以內",
            type: .transit,
            host: sean,
            summary: "預計叫七人座直達桃園機場第二航廈，會先在群組確認班機與集合時間，車資平均分攤。",
            tags: ["交通", "機場", "共乘"],
            accent: .blue,
            pinX: 0.49,
            pinY: 0.39,
            latitude: 25.0476,
            longitude: 121.5171
        )
        let libraryStudy = JoinCommission(
            title: "圖書館讀書互相顧位",
            area: "台北大安",
            place: "國立臺灣大學圖書館",
            timeText: "8/5 13:00",
            participantText: "1 / 3 人",
            requirement: "可安靜讀書至少兩小時",
            type: .other,
            customTypeTitle: "讀書",
            host: fish,
            summary: "各自讀自己的內容，中間輪流休息、幫忙顧位，結束前分享一下今天完成的進度。",
            tags: ["其他", "讀書", "專注"],
            accent: .brown,
            pinX: 0.50,
            pinY: 0.55,
            latitude: 25.0174,
            longitude: 121.5406
        )
        let furnitureHelp = JoinCommission(
            title: "IKEA 組裝桌子缺一雙手",
            area: "新北板橋",
            place: "板橋車站附近社區",
            timeText: "8/11 14:00",
            participantText: "1 / 2 人",
            requirement: "不限性別，能協助扶桌板即可",
            type: .other,
            customTypeTitle: "生活互助",
            host: sean,
            summary: "桌子零件和工具都已備妥，主要需要有人在鎖螺絲時幫忙扶穩，完成後請喝飲料。",
            tags: ["其他", "生活互助", "30分鐘"],
            accent: .teal,
            pinX: 0.30,
            pinY: 0.48,
            latitude: 25.0143,
            longitude: 121.4641
        )

        commissions = [
            milkTea,
            coffeeChat,
            basketball,
            flMusic,
            nightMarket,
            oldHouseCafe,
            animationPremiere,
            expo,
            elephantMountainWalk,
            concert,
            libraryStudy,
            brunch,
            dessertPhoto,
            pokemonCards,
            acousticJam,
            riverRun,
            resumePractice,
            riversideWalk,
            airportRide,
            furnitureHelp,
            cafePhoto
        ]
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
        let priorityTags = ["15分鐘", "30分鐘", "低壓", "健身", "職涯", "音樂"]
        let tags = Set(commissions.flatMap(\.tags))
        let remainingTags = tags.filter { !priorityTags.contains($0) }.sorted()
        return priorityTags.filter(tags.contains) + remainingTags
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
