//
//  Majlis.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 13/08/1447 AH.
//

import SwiftUI

struct Majlis: View {

    // ✅ عدّلي أسماء الصور من هنا إذا لزم
    private enum Assets {
        static let circleBG = "shapeb"
        static let finjan = "finjal"
        static let dates  = "tamer"
        static let dallah = "dallah"
        static let incense = "mabkhara"
    }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MajlisViewModel
    let region: Region

    init(viewModel: MajlisViewModel, region: Region) {
        self.viewModel = viewModel
        self.region = region
    }

    var body: some View {
        ZStack {

            Color(red: 0.98, green: 0.91, blue: 0.78)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                HStack {

                    xpBar(value: viewModel.xp)

                    Spacer()

                    Button { dismiss() } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.brown)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer(minLength: 10)

                Text(viewModel.cardText)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(16)
                    .padding(.horizontal)

                Spacer(minLength: 20)

                ZStack(alignment: .bottom) {

                    Image("sofa")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)

                    if !viewModel.characterImageName.isEmpty {
                        Image(viewModel.characterImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180)
                            .offset(y: -20)
                    } else {
                        Text("ما تم اختيار شخصية")
                            .foregroundStyle(.red)
                            .padding(.bottom, 40)
                    }
                }

                Spacer(minLength: 20)

                bottomArea

                Spacer(minLength: 10)

                TrianglePatternView(color: .brown, height: 30, triangleWidth: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $viewModel.showCoffeeGame) {

            CoffeeGameView(
                region: region
            ) {
                viewModel.coffeeGameFinishedSuccessfully()
            }
        }
    }

    private func xpBar(value: Int) -> some View {
        let maxPoints = 10
        let width: CGFloat = 140
        let fill = CGFloat(min(value, maxPoints)) / CGFloat(maxPoints)

        return ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.white)
                .frame(width: width, height: 18)

            Capsule()
                .fill(Color.yellow)
                .frame(width: max(10, width * fill), height: 12)
                .padding(.leading, 3)
        }
    }

    @ViewBuilder
    private var bottomArea: some View {
        switch viewModel.step {

        case .coffeeHintChoices:
            HStack(spacing: 24) {
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.incense, enabled: false) { }
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dates,  enabled: false) { }
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.dallah, enabled: true)  {
                    viewModel.tapDallahToOpenCoffeeGame()
                }
            }

        case .datesQuestion:
            HStack(spacing: 24) {
                OptionCircle(bgName: Assets.circleBG, iconName: Assets.finjan, enabled: viewModel.selectedIconKey == nil) {
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
            Button {
                viewModel.tapStart()
            } label: {
                Text("ابدأ")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.brown)
                    .clipShape(Capsule())
            }

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
            Button {
                viewModel.goToFoodQuestion()
            } label: {
                Text("التالي")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.brown)
                    .clipShape(Capsule())
            }

        case .foodQuestion:
            let q = viewModel.foodQuestion
            HStack(spacing: 24) {
                ForEach(q.answers) { ans in
                    AnswerCircle(text: ans.text, state: viewModel.circleState(for: ans))
                        .onTapGesture { viewModel.chooseFoodAnswer(ans) }
                }
            }

        case .finished:
            Button {
                viewModel.restartSession()
            } label: {
                Text("إعادة")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.brown)
                    .clipShape(Capsule())
            }
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
                    .frame(width: 95, height: 95)

                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
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
                .fill(Color(red: 0.86, green: 0.75, blue: 0.63))
                .frame(width: 75, height: 75)

            Text(text)
                .font(.headline)
                .foregroundColor(.black)
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
            .fill(color)
        }
        .frame(height: height)
    }
}

#Preview {
    let vm = MajlisViewModel(region: .western)
    vm.selectedCharacter = .female
    return Majlis(viewModel: vm, region: .western)
}

