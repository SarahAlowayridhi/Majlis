//
//  Majlis.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 13/08/1447 AH.
//

import SwiftUI

struct Majlis: View {

    // MARK: - Assets
    private enum Assets {
        static let circleBG = "shapeb"
        static let finjan   = "finjal"
        static let dates    = "tamer"
        static let dallah   = "dallah"
        static let incense  = "mabkhara"
        static let sofa     = "sofa"
    }

    // MARK: - Layout Constants
    private let triangleHeight: CGFloat = 30

    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MajlisViewModel
    let region: Region

    init(viewModel: MajlisViewModel, region: Region) {
        self.viewModel = viewModel
        self.region = region
    }

    // MARK: - Coffee Game Screen (FIX)
    private var coffeeGameScreen: some View {
        CoffeeGameView(
            region: region,
            onFinished: viewModel.coffeeGameFinishedSuccessfully
        )
    }

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {

            // ✅ Background from Assets (supports Dark Mode)
            Color("background")
                .ignoresSafeArea()

            contentLayer
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $viewModel.showCoffeeGame) {
            coffeeGameScreen
        }

        // ✅ Triangles fixed at the bottom + flipped
        .safeAreaInset(edge: .bottom, spacing: 0) {
            TrianglePatternView(color: .brown, height: 20, triangleWidth: 20)
                .rotationEffect(.degrees(180))
                .frame(height: triangleHeight)
                .offset(y: 39)
        }

        // ✅ Result popup overlay
        .overlay {
            resultPopupLayer
        }
    }

    // MARK: - Main Content Layer
    private var contentLayer: some View {
        ZStack {

            // ✅ Sofa & character ثابتين بمكانهم
            GeometryReader { geo in
                sofaLayer
                    .frame(maxWidth: geo.size.width)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * 0.74
                    )
            }
            .ignoresSafeArea()

            // ✅ UI layer فوق الصورة
            VStack(spacing: 18) {

                header

                cardTextSection

                Spacer(minLength: 0)

                bottomArea
                    .padding(.bottom, 12)
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, triangleHeight + 6)
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            progressBar(current: viewModel.progressCurrent, total: viewModel.progressTotal)
            Spacer()

            Button { dismiss() } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.brown)
                    .clipShape(Circle())
            }
        }
    }

    // MARK: - Card Text Section
    private var cardTextSection: some View {
        Group {
            if viewModel.step != .finished {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                        .frame(height: 120)

                    Text(viewModel.cardText)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.85)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
            } else {
                Color.clear.frame(height: 92)
            }
        }
    }

    // MARK: - Sofa Layer
    private var sofaLayer: some View {
        ZStack(alignment: .center) {
            Image(Assets.sofa)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .offset(y: -138)

            if !viewModel.characterImageName.isEmpty {
                Image(viewModel.characterImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .offset(y: -180)
            }
        }
    }

    // MARK: - Result Popup Layer
    @ViewBuilder
    private var resultPopupLayer: some View {
        if viewModel.step == .finished {

            let perfect = viewModel.didAnswerAllCorrect

            ResultPopup(
                title: perfect ? "تمّت علومك، ما بقي عليك شي" : "العلوم ما تجي بيوم وليلة!",
                message: perfect
                    ? "أبدعت، وكأنك من الأولين"
                    : "جاوبت على \(viewModel.correctCount) من أصل \(viewModel.totalCount)",
                primaryTitle: perfect ? "الانتقال للخريطة" : "إعادة المحاولة",
                onPrimary: {
                    if perfect {
                        dismiss()                 // ✅ يرجع للخريطة
                    } else {
                        viewModel.restartSession()
                    }
                },
                secondaryTitle: nil,             // ✅ شلنا زر الإغلاق
                onSecondary: nil
            )
        }
    }

    // MARK: - Progress Bar
    private func progressBar(current: Int, total: Int) -> some View {
        let width: CGFloat = 130
        let height: CGFloat = 18

        let safeTotal = max(total, 1)
        let progress = CGFloat(min(max(current, 0), safeTotal)) / CGFloat(safeTotal)

        let dotSize = height
        let fillWidth = max(dotSize, width * progress)

        return ZStack(alignment: .leading) {

            Capsule()
                .fill(Color.white)
                .frame(width: width, height: height)

            Capsule()
                .fill(Color.yellow)
                .frame(width: fillWidth, height: height)
                .animation(.easeInOut(duration: 0.25), value: current)

            ZStack {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: dotSize, height: dotSize)

                if current > 0 {
                    Text(arabicNumber(current))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .frame(width: dotSize, height: dotSize)
        }
    }

    // تحويل 1,2,3 إلى ١،٢،٣
    private func arabicNumber(_ n: Int) -> String {
        let map: [Character: Character] = [
            "0":"٠","1":"١","2":"٢","3":"٣","4":"٤",
            "5":"٥","6":"٦","7":"٧","8":"٨","9":"٩"
        ]
        return String(n).map { map[$0] ?? $0 }.reduce("") { $0 + String($1) }
    }

    // MARK: - Bottom Area
    @ViewBuilder
    private var bottomArea: some View {
        switch viewModel.step {

        case .coffeeHintChoices:
            HStack(spacing: 24) {
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.incense, enabled: false) {}
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dates, enabled: false) {}
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dallah, enabled: true) {
                    viewModel.tapDallahToOpenCoffeeGame()
                }
            }

        case .datesQuestion:
            HStack(spacing: 24) {
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.incense, enabled: viewModel.selectedIconKey == nil) {
                    viewModel.answerDates(iconKey: Assets.finjan, isCorrect: false)
                }
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dates, enabled: viewModel.selectedIconKey == nil) {
                    viewModel.answerDates(iconKey: Assets.dates, isCorrect: true)
                }
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dallah, enabled: viewModel.selectedIconKey == nil) {
                    viewModel.answerDates(iconKey: Assets.dallah, isCorrect: false)
                }
            }

        case .incenseQuestion:
            HStack(spacing: 24) {
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.incense, enabled: viewModel.selectedIconKey == nil) {
                    viewModel.answerIncense(iconKey: Assets.incense, isCorrect: true)
                }
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dates, enabled: viewModel.selectedIconKey == nil) {
                    viewModel.answerIncense(iconKey: Assets.dates, isCorrect: false)
                }
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.finjan, enabled: viewModel.selectedIconKey == nil) {
                    viewModel.answerIncense(iconKey: Assets.finjan, isCorrect: false)
                }
            }

        case .staticStartPage:
            Button("ابدأ") {
                viewModel.tapStart()
            }
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 100, height: 35)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.brown)
            .clipShape(Capsule())

        case .proverbQuestion:
            if let q = viewModel.proverbQuestion {
                HStack(spacing: 24) {
                    ForEach(q.answers) { ans in
                        AnswerCircle(text: ans.text, state: viewModel.circleState(for: ans))
                            .onTapGesture { viewModel.chooseProverbAnswer(ans) }
                    }
                }
            } else {
                Text("لا توجد خيارات")
                    .foregroundStyle(.brown)
            }

        case .proverbExplanation:
            Button("التالي") {
                viewModel.goToFoodQuestion()
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(width: 100, height: 50)
            .background(Color.brown)
            .clipShape(Capsule())

        case .foodQuestion:
            let q = viewModel.foodQuestion
            HStack(spacing: 24) {
                ForEach(q.answers) { ans in
                    AnswerCircle(text: ans.text, state: viewModel.circleState(for: ans))
                        .onTapGesture { viewModel.chooseFoodAnswer(ans) }
                }
            }

        case .finished:
            EmptyView()
        }
    }
}

// MARK: - Result Popup
private struct ResultPopup: View {

    let title: String
    let message: String
    let primaryTitle: String
    let onPrimary: () -> Void

    // ✅ اختياري (إذا nil ما يطلع زر)
    let secondaryTitle: String?
    let onSecondary: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 14) {

                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)

                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.primary)

                Button(primaryTitle) { onPrimary() }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.brown)
                    .clipShape(Capsule())

                // ✅ يظهر فقط إذا موجود
                if let secondaryTitle, let onSecondary {
                    Button(secondaryTitle) { onSecondary() }
                        .font(.subheadline)
                        .foregroundColor(.brown)
                        .padding(.top, 2)
                }
            }
            .padding(18)
            .frame(maxWidth: 340)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Option Circle
private struct OptionCircle: View {

    let bgName: String
    let iconName: String
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Image(bgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)

                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
            }
            .opacity(enabled ? 1.0 : 0.6)
        }
        .disabled(!enabled)
    }
}

// MARK: - Answer Circle
enum AnswerCircleState {
    case idle
    case correct
    case wrong
}

struct AnswerCircle: View {

    let text: String
    let state: AnswerCircleState

    private var ringColor: Color {
        switch state {
        case .idle:    return Color.brown.opacity(0.8)
        case .correct: return Color.green
        case .wrong:   return Color.red
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(ringColor, lineWidth: 6)
                .frame(width: 90, height: 90)

            Circle()
                .fill(Color("AnswerFill", bundle: .main))
                .overlay(
                    Circle().fill(Color.primary.opacity(0.03))
                )
                .frame(width: 75, height: 75)

            Text(text)
                .font(.headline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
                .foregroundStyle(Color.primary)
                .padding(.horizontal, 6)
        }
    }
}

// MARK: - Triangle Pattern
struct TrianglePatternView: View {

    let color: Color
    let height: CGFloat
    let triangleWidth: CGFloat

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let width = geo.size.width
                var x: CGFloat = 0

                while x < width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x + triangleWidth / 2, y: height))
                    path.addLine(to: CGPoint(x: x + triangleWidth, y: 0))
                    path.closeSubpath()
                    x += triangleWidth
                }
            }
            .fill(Color(red: 0.41, green: 0.28, blue: 0.20))
        }
        .frame(height: height)
    }
}

#Preview {
    let vm = MajlisViewModel(region: .western)
    vm.selectedCharacter = .female
    return Majlis(viewModel: vm, region: .western)
        .preferredColorScheme(.light)
}

