import Observation
import SwiftUI

enum OnboardingStep: Int, Equatable {
    case chooseLowPressure = 1
    case chooseCommission
    case confirmDetails
    case apply
    case result
}

@MainActor
@Observable
final class OnboardingGuideState {
    var step: OnboardingStep = .chooseLowPressure
    var showsWelcome = true
    var showsScrollConfirmation = false

    func beginTutorial() {
        showsWelcome = false
    }

    func advance(to step: OnboardingStep) {
        self.step = step
    }

    func reset() {
        step = .chooseLowPressure
        showsWelcome = true
        showsScrollConfirmation = false
    }

    func moveToApplication() {
        step = .apply
        showsScrollConfirmation = true

        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(1.2))
            guard self?.step == .apply else { return }
            self?.showsScrollConfirmation = false
        }
    }
}

struct OnboardingWelcomeView: View {
    var startTutorial: () -> Void

    var body: some View {
        ZStack {
            JoinMeStyle.background
                .ignoresSafeArea()

            Circle()
                .fill(JoinMeStyle.leaf.opacity(0.1))
                .frame(width: 320, height: 320)
                .blur(radius: 2)
                .offset(x: 150, y: -300)

            VStack(alignment: .leading, spacing: 24) {
                JoinMeWordmark()

                Spacer()

                ZStack {
                    BrandGradient()
                        .frame(width: 88, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    Image(systemName: "link")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)
                }
                .shadow(color: JoinMeStyle.leaf.opacity(0.22), radius: 18, y: 8)

                VStack(alignment: .leading, spacing: 10) {
                    Label("新手教學", systemImage: "sparkles")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(JoinMeStyle.leaf)

                    Text("先用 1 分鐘，找到剛好的同行")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(JoinMeStyle.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("跟著 5 個步驟，從挑選低壓委託到送出申請。")
                        .font(.body)
                        .foregroundStyle(JoinMeStyle.secondaryInk)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Label("活動優先，不用先變熟", systemImage: "figure.walk")
                    Label("時間地點清楚，安心再加入", systemImage: "checkmark.shield.fill")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(JoinMeStyle.ink)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(JoinMeStyle.leaf.opacity(0.16))
                }

                Spacer()

                Button(action: startTutorial) {
                    Label("開始教學", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityIdentifier("startOnboardingTutorialButton")

                Text("共 5 步 · 約 1 分鐘")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(JoinMeStyle.secondaryInk)
                    .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
        .accessibilityIdentifier("onboardingWelcome")
    }
}

struct OnboardingProgressPill: View {
    var step: OnboardingStep

    var body: some View {
        Text("\(step.rawValue)/5")
            .font(.caption2.weight(.bold))
            .foregroundStyle(JoinMeStyle.leaf)
            .monospacedDigit()
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background(JoinMeStyle.leaf.opacity(0.08), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(JoinMeStyle.leaf.opacity(0.18))
            }
            .accessibilityLabel("新手引導第 \(step.rawValue) 步，共 5 步")
    }
}

struct OnboardingStepPrompt: View {
    var title: String
    var detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkles")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(JoinMeStyle.leaf, in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text("教學第 1 步")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(JoinMeStyle.leaf)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(JoinMeStyle.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(JoinMeStyle.secondaryInk)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(JoinMeStyle.leaf.opacity(0.55), lineWidth: 1.5)
        }
        .shadow(color: JoinMeStyle.leaf.opacity(0.12), radius: 10, y: 4)
    }
}

struct OnboardingTargetHalo: View {
    var cornerRadius: CGFloat
    @State private var isBreathing = false

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(JoinMeStyle.leaf, lineWidth: 2.2)
            .padding(-4)
            .opacity(isBreathing ? 0.32 : 0.82)
            .animation(
                .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                value: isBreathing
            )
            .onAppear { isBreathing = true }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

struct OnboardingCallout: View {
    var title: String
    var systemImage: String = "hand.tap.fill"

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(JoinMeStyle.leaf, in: Capsule())
            .shadow(color: JoinMeStyle.leaf.opacity(0.24), radius: 8, y: 3)
            .accessibilityHidden(true)
    }
}

struct OnboardingRecommendationReason: View {
    var body: some View {
        Label("為你挑到：15 分鐘・低壓・拿到就散", systemImage: "sparkles")
            .font(.caption.weight(.bold))
            .foregroundStyle(JoinMeStyle.leaf)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(JoinMeStyle.leaf.opacity(0.09), in: Capsule())
    }
}

struct OnboardingResultBanner: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label("完成！申請已送出", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(JoinMeStyle.leaf)
            Text("錄取後才會開啟活動聊天室，活動結束後會自動封存。")
                .font(.subheadline)
                .foregroundStyle(JoinMeStyle.secondaryInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(JoinMeStyle.leaf.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}
