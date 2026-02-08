//
//  Majlis.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 13/08/1447 AH.


import SwiftUI

struct Majlis: View {

    @Environment(\.dismiss) private var dismiss

    // هذا الـ VM حق الشخصية + الاسم (جاي من CharacterSelection)
    @ObservedObject var viewModel: MajlisViewModel

    // المنطقة المختارة من الخريطة
    let region: Region

    // أسئلة المنطقة
    private let questions: [Question]

    // MARK: - Quiz State (داخل المجلس)
    @State private var currentIndex: Int = 0
    @State private var selectedAnswerID: UUID? = nil
    @State private var lastAnswerWasCorrect: Bool? = nil
    @State private var score: Int = 0
    @State private var finished: Bool = false

    init(viewModel: MajlisViewModel, region: Region) {
        self.viewModel = viewModel
        self.region = region
        self.questions = QuestionsBank.questions(for: region)
    }

    // MARK: - Helpers
    private var currentQuestion: Question? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        ZStack {

            Color(red: 0.98, green: 0.91, blue: 0.78)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: - Header
                HStack {

                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .scaleEffect(0.9)

                    Spacer()

                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.brown)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer(minLength: 10)

                // MARK: - Text Card (Question)
                Group {
                    if finished {
                        Text("خلصنا ✅\nنتيجتك: \(score) / \(questions.count)")
                    } else {
                        Text(currentQuestion?.text ?? "ما فيه أسئلة لهذه المنطقة")
                    }
                }
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.75))
                .cornerRadius(16)
                .padding(.horizontal)

                Spacer(minLength: 20)

                // MARK: - Sofa + Character
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

                // MARK: - Answers (3 Circles)
                if finished {
                    Button {
                        restartQuiz()
                    } label: {
                        Text("إعادة")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.brown)
                            .clipShape(Capsule())
                    }
                } else {
                    HStack(spacing: 24) {
                        if let q = currentQuestion {
                            ForEach(q.answers) { ans in
                                AnswerCircle(
                                    text: ans.text,
                                    state: answerCircleState(for: ans)
                                )
                                .onTapGesture {
                                    choose(ans)
                                }
                            }
                        } else {
                            // لو ما فيه أسئلة
                            Text("لا توجد خيارات")
                                .foregroundStyle(.brown)
                        }
                    }
                }

                Spacer(minLength: 10)

                TrianglePatternView(color: .brown, height: 30, triangleWidth: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            finished = questions.isEmpty
        }
    }

    // MARK: - Quiz Logic
    private func choose(_ answer: Answer) {
        // منع الضغط مرتين
        guard selectedAnswerID == nil else { return }

        selectedAnswerID = answer.id
        lastAnswerWasCorrect = answer.isCorrect

        if answer.isCorrect { score += 1 }

        // انتقال تلقائي بعد لحظة
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            next()
        }
    }

    private func next() {
        let nextIndex = currentIndex + 1
        if nextIndex < questions.count {
            currentIndex = nextIndex
            selectedAnswerID = nil
            lastAnswerWasCorrect = nil
        } else {
            finished = true
        }
    }

    private func restartQuiz() {
        currentIndex = 0
        score = 0
        finished = questions.isEmpty
        selectedAnswerID = nil
        lastAnswerWasCorrect = nil
    }

    private func answerCircleState(for answer: Answer) -> AnswerCircleState {
        // قبل الاختيار: عادي
        guard let selected = selectedAnswerID else { return .idle }

        // المختار فقط هو اللي يتلوّن
        guard selected == answer.id else { return .idle }

        return (answer.isCorrect) ? .correct : .wrong
    }
}

// MARK: - Answer Circle Component
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
    let vm = MajlisViewModel()
    vm.selectedCharacter = .female
    return Majlis(viewModel: vm, region: .central)
}

