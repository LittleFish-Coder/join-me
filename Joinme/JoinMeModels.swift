import Foundation
import CoreLocation
import SwiftUI

enum JoinRequestStatus: String, Codable {
    case none
    case pending
    case accepted
    case declined

    var label: String {
        switch self {
        case .none: "尚未投遞"
        case .pending: "等待審核"
        case .accepted: "已錄取"
        case .declined: "未錄取"
        }
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case explore
    case review
    case chats
    case trust

    var id: String { rawValue }

    var title: String {
        switch self {
        case .explore: "探索"
        case .review: "審核"
        case .chats: "聊天室"
        case .trust: "個人"
        }
    }

    var symbolName: String {
        switch self {
        case .explore: "sparkle.magnifyingglass"
        case .review: "person.crop.circle.badge.checkmark"
        case .chats: "bubble.left.and.bubble.right"
        case .trust: "person.crop.circle"
        }
    }
}

enum BiologicalSex: String, CaseIterable, Identifiable, Hashable {
    case female = "女性"
    case male = "男性"
    case intersex = "雙性／間性"
    case undisclosed = "不公開"

    var id: String { rawValue }
}

enum CommissionType: String, CaseIterable, Identifiable, Hashable {
    case immediate
    case food
    case cafe
    case fandom
    case music
    case fitness
    case career
    case walk
    case transit
    case other

    static var selectableCases: [CommissionType] {
        [.food, .cafe, .fandom, .music, .fitness, .career, .walk, .transit, .other]
    }

    var id: String { rawValue }

    var title: String {
        switch self {
        case .immediate: "立即委託"
        case .food: "吃喝"
        case .cafe: "跑咖拍照"
        case .fandom: "同好"
        case .music: "音樂"
        case .fitness: "健身"
        case .career: "職涯"
        case .walk: "散步"
        case .transit: "交通同行"
        case .other: "其他"
        }
    }

    var symbolName: String {
        switch self {
        case .immediate: "bolt.fill"
        case .food: "cup.and.saucer.fill"
        case .cafe: "camera.fill"
        case .fandom: "star.bubble.fill"
        case .music: "music.note.list"
        case .fitness: "figure.strengthtraining.traditional"
        case .career: "briefcase.fill"
        case .walk: "figure.walk"
        case .transit: "tram.fill"
        case .other: "square.grid.2x2.fill"
        }
    }

    var defaultTag: String {
        switch self {
        case .immediate: "立即委託"
        case .food: "吃喝"
        case .cafe: "跑咖"
        case .fandom: "同好"
        case .music: "音樂"
        case .fitness: "健身"
        case .career: "職涯"
        case .walk: "散步"
        case .transit: "交通"
        case .other: "其他"
        }
    }

    var isUserCustomizable: Bool {
        self == .other
    }
}

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    var name: String
    var handle: String
    var avatar: String
    var age: Int
    var biologicalSex: BiologicalSex
    var neighborhood: String
    var bio: String
    var pigeonIndex: Int
    var punctuality: Int
    var completedEvents: Int
    var tags: [String]

    init(
        id: UUID = UUID(),
        name: String,
        handle: String,
        avatar: String,
        age: Int,
        biologicalSex: BiologicalSex,
        neighborhood: String,
        bio: String,
        pigeonIndex: Int,
        punctuality: Int,
        completedEvents: Int,
        tags: [String]
    ) {
        self.id = id
        self.name = name
        self.handle = handle
        self.avatar = avatar
        self.age = age
        self.biologicalSex = biologicalSex
        self.neighborhood = neighborhood
        self.bio = bio
        self.pigeonIndex = pigeonIndex
        self.punctuality = punctuality
        self.completedEvents = completedEvents
        self.tags = tags
    }
}

struct JoinCommission: Identifiable, Hashable {
    let id: UUID
    var title: String
    var area: String
    var place: String
    var timeText: String
    var participantText: String
    var requirement: String
    var type: CommissionType
    var customTypeTitle: String?
    var host: UserProfile
    var summary: String
    var tags: [String]
    var accent: Color
    var pinX: Double
    var pinY: Double
    var latitude: Double
    var longitude: Double
    var isHostedByCurrentUser: Bool

    init(
        id: UUID = UUID(),
        title: String,
        area: String,
        place: String,
        timeText: String,
        participantText: String,
        requirement: String,
        type: CommissionType,
        customTypeTitle: String? = nil,
        host: UserProfile,
        summary: String,
        tags: [String],
        accent: Color,
        pinX: Double,
        pinY: Double,
        latitude: Double,
        longitude: Double,
        isHostedByCurrentUser: Bool = false
    ) {
        self.id = id
        self.title = title
        self.area = area
        self.place = place
        self.timeText = timeText
        self.participantText = participantText
        self.requirement = requirement
        self.type = JoinCommission.isImmediateStartText(timeText) ? .immediate : type
        self.customTypeTitle = JoinCommission.isImmediateStartText(timeText) ? nil : customTypeTitle
        self.host = host
        self.summary = summary
        self.tags = tags
        self.accent = accent
        self.pinX = pinX
        self.pinY = pinY
        self.latitude = latitude
        self.longitude = longitude
        self.isHostedByCurrentUser = isHostedByCurrentUser
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var typeTitle: String {
        guard type == .other else { return type.title }
        let trimmed = customTypeTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? type.title : trimmed
    }

    var typeSymbolName: String {
        type.symbolName
    }

    static func isImmediateStartText(_ text: String) -> Bool {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return ["現在", "馬上", "稍晚", "今天", "今晚"].contains { normalized.contains($0) }
    }
}

struct JoinApplication: Identifiable, Hashable {
    let id: UUID
    var commissionID: UUID
    var applicant: UserProfile
    var note: String
    var status: JoinRequestStatus

    init(id: UUID = UUID(), commissionID: UUID, applicant: UserProfile, note: String, status: JoinRequestStatus = .pending) {
        self.id = id
        self.commissionID = commissionID
        self.applicant = applicant
        self.note = note
        self.status = status
    }
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    var sender: String
    var body: String
    var timeText: String
    var isMine: Bool
}

struct ActivityChat: Identifiable, Hashable {
    let id: UUID
    var commissionID: UUID
    var title: String
    var place: String
    var timeText: String
    var archiveText: String
    var isArchived: Bool
    var participants: [UserProfile]
    var messages: [ChatMessage]

    init(
        id: UUID = UUID(),
        commissionID: UUID,
        title: String,
        place: String,
        timeText: String,
        archiveText: String,
        isArchived: Bool = false,
        participants: [UserProfile],
        messages: [ChatMessage]
    ) {
        self.id = id
        self.commissionID = commissionID
        self.title = title
        self.place = place
        self.timeText = timeText
        self.archiveText = archiveText
        self.isArchived = isArchived
        self.participants = participants
        self.messages = messages
    }
}

struct CompletedActivity: Identifiable, Hashable {
    let id: UUID
    var commissionID: UUID
    var title: String
    var participantIDs: [UUID]
    var completedAtText: String

    init(
        id: UUID = UUID(),
        commissionID: UUID,
        title: String,
        participantIDs: [UUID],
        completedAtText: String
    ) {
        self.id = id
        self.commissionID = commissionID
        self.title = title
        self.participantIDs = participantIDs
        self.completedAtText = completedAtText
    }
}

struct EventReview: Identifiable, Hashable {
    let id: UUID
    var activityID: UUID
    var reviewerID: UUID
    var revieweeID: UUID
    var punctuality: Int
    var communication: Int
    var completion: Int
    var comment: String

    init(
        id: UUID = UUID(),
        activityID: UUID,
        reviewerID: UUID,
        revieweeID: UUID,
        punctuality: Int,
        communication: Int,
        completion: Int,
        comment: String
    ) {
        self.id = id
        self.activityID = activityID
        self.reviewerID = reviewerID
        self.revieweeID = revieweeID
        self.punctuality = punctuality
        self.communication = communication
        self.completion = completion
        self.comment = comment
    }

    var score: Int {
        Int((Double(punctuality + communication + completion) / 15 * 100).rounded())
    }
}

struct PendingReview: Identifiable, Hashable {
    var activity: CompletedActivity
    var reviewee: UserProfile

    var id: String { "\(activity.id.uuidString)-\(reviewee.id.uuidString)" }
}
