//
//  dallh.swift
//  Majlis
//
//  Created by maha althwab on 13/08/1447 AH.
//
import SwiftUI

struct CoffeeGameView: View {

    // MARK: - Inputs
    let region: Region
    let onFinished: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    // MARK: - Pour States
    @State private var fillAmount: CGFloat = 0.0
    @State private var fillTimer: Timer?
    @State private var dallahRotation: Double = 0
    @State private var result: ResultState = .idle
    @State private var isPouring: Bool = false

    // MARK: - Ingredient States
    @State private var circleStates: [String: CoffeeCircleState] = [:]

    let targetWidth: CGFloat = 0.33

    // MARK: - Init
    init(region: Region, onFinished: (() -> Void)? = nil) {
        self.region = region
        self.onFinished = onFinished
    }

    // MARK: - Data
    var coffeeOptions: [CoffeeOption] {
        CoffeeData.options(for: region)
    }

    // MARK: - Body
    var body: some View {

        ZStack {

            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()

            VStack {

                // MARK: - Ingredient Choices
                HStack(spacing: 24) {

                    ForEach(coffeeOptions) { option in

                        CoffeeAnswerCircle(
                            text: option.text,
                            state: circleState(for: option)
                        )
                        .onTapGesture {
                            handleIngredientTap(option)
                        }
                    }
                }
                .padding(.top, 140)
                .opacity(isPouring ? 0 : 1)   // تختفي بس مكانها ثابت
                .allowsHitTesting(!isPouring) // ما تنضغط وقت الصب

                // MARK: - Hint
                Text(hintText)
                    .font(.headline)
                    .foregroundColor(hintColor)
                    .padding(.top, 8)

                Spacer()

                // MARK: - Cup + Dallah
                HStack(alignment: .bottom, spacing: -10) {

                    Image(currentCupImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .offset(x: 20, y: 10)

                    Image("dallah")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240)
                        .rotationEffect(.degrees(dallahRotation),
                                        anchor: .topLeading)
                        .offset(x: -10, y: -5)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    tiltDallah()
                                    startFilling()
                                }
                                .onEnded { _ in
                                    resetDallah()
                                    stopFilling()
                                }
                        )
                        .animation(.easeInOut(duration: 0.25),
                                   value: dallahRotation)
                }

                Spacer()

                // MARK: - Progress Bar
                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(Color.white)
                        .frame(width: 300, height: 26)

                    Capsule()
                        .fill(Color.brown.opacity(0.35))
                        .frame(width: 300 * targetWidth,
                               height: 18)
                        .padding(.leading, 4)

                    Capsule()
                        .fill(progressColor)
                        .frame(
                            width: (300 - 8) * fillAmount,
                            height: 18
                        )
                        .padding(.leading, 4)
                }
                .padding(.bottom, 50)
            }
        }
        .animation(.easeInOut, value: isPouring)
    }
}

// MARK: - Ingredient Logic

extension CoffeeGameView {

    func handleIngredientTap(_ option: CoffeeOption) {

        if option.isCorrect {

            circleStates[option.id] = .correct

        } else {

            circleStates[option.id] = .wrong

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                circleStates[option.id] = .idle
            }
        }
    }

    func circleState(for option: CoffeeOption) -> CoffeeCircleState {
        circleStates[option.id] ?? .idle
    }
}
// MARK: - Hint

extension CoffeeGameView {

    var hintText: String {
        "اختار المكونات و صبّ القهوة ☕️"
    }

    var hintColor: Color {
        .brown
    }
}

// MARK: - Pour Logic

extension CoffeeGameView {

    enum ResultState { case idle, success, fail }

    var currentCupImage: String {
        result == .fail ? "failcup" : "redcup"
    }

    func tiltDallah() { dallahRotation = -40 }
    func resetDallah() { dallahRotation = 0 }

    func startFilling() {

        isPouring = true
        result = .idle

        guard fillTimer == nil else { return }

        fillTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.linear(duration: 0.05)) {
                fillAmount = fillAmount < 1.0 ? fillAmount + 0.01 : 0.0
            }
        }
    }

    func stopFilling() {
        fillTimer?.invalidate()
        fillTimer = nil
        checkResult()
    }

    func checkResult() {

        let tolerance: CGFloat = 0.02

        if abs(fillAmount - targetWidth) <= tolerance {

            result = .success

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                onFinished?()
                dismiss()
            }

        } else if fillAmount > targetWidth {

            result = .fail

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {

                isPouring = false
                fillAmount = 0
                result = .idle
            }

        } else {
            result = .idle
        }
    }

    var progressColor: Color {
        switch result {
        case .idle: return .yellow
        case .success: return .green
        case .fail: return .red
        }
    }
}

// MARK: - Circle Component

enum CoffeeCircleState {
    case idle
    case correct
    case wrong
}

struct CoffeeAnswerCircle: View {

    let text: String
    let state: CoffeeCircleState

    private var ringColor: Color {
        switch state {
        case .idle: return .brown.opacity(0.8)
        case .correct: return .green
        case .wrong: return .red
        }
    }

    var body: some View {

        ZStack {

            Circle()
                .stroke(ringColor, lineWidth: 6)
                .frame(width: 110, height: 110)

            Circle()
                .fill(Color(red: 0.86, green: 0.75, blue: 0.63))
                .frame(width: 90, height: 90)

            Text(text)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
    }
}

// MARK: - Preview
#Preview {
    CoffeeGameView(region: .central)
}

