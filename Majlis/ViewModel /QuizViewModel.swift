//
//  QuizViewModel.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 20/08/1447 AH.
//

import Foundation
import Combine

@MainActor
final class QuizViewModel: ObservableObject {

    // Input
    let region: Region

    // Data
    @Published private(set) var questions: [Question] = []

    // State
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var selectedAnswerID: UUID? = nil
    @Published private(set) var lastAnswerWasCorrect: Bool? = nil
    @Published private(set) var score: Int = 0
    @Published private(set) var finished: Bool = false
    @Published var showResultSheet: Bool = false

    // MARK: - Init
    init(region: Region) {
        self.region = region
        self.questions = QuestionsBank.questions(for: region)
        self.finished = questions.isEmpty
        self.showResultSheet = false
    }

    // MARK: - Computed
    var currentQuestion: Question? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }

    /// عدد الدوائر تحت (حسب عدد الأسئلة)
    var totalQuestions: Int { questions.count }

    /// ✅ NEW: نص النتيجة بدل Total XP
    var resultMessage: String {
        "جاوبت على \(score) من أصل \(totalQuestions) هل تريد إعادة المحاولة؟"
    }

    // MARK: - Actions
    func choose(answer: Answer) {
        // لا تخلي المستخدم يضغط مرتين على نفس السؤال
        guard selectedAnswerID == nil else { return }

        selectedAnswerID = answer.id
        lastAnswerWasCorrect = answer.isCorrect

        if answer.isCorrect { score += 1 }
    }

    func next() {
        // لازم يكون اختار أول
        guard selectedAnswerID != nil else { return }

        let nextIndex = currentIndex + 1
        if nextIndex < questions.count {
            currentIndex = nextIndex
            // reset selection state للسؤال الجديد
            selectedAnswerID = nil
            lastAnswerWasCorrect = nil
        } else {
            finished = true
            // ✅ NEW: show result UI
            showResultSheet = true
        }
    }

    func restart() {
        currentIndex = 0
        score = 0
        finished = questions.isEmpty
        selectedAnswerID = nil
        lastAnswerWasCorrect = nil
        // ✅ NEW
        showResultSheet = false
    }

    // MARK: - UI Helpers (للدواير)
    func circleState(at index: Int) -> CircleState {
        if finished {
            // بعد النهاية: نعتبر اللي قبل المؤشر كلها "تمّت"
            return index < questions.count ? .done : .idle
        }

        if index < currentIndex { return .done }        // أسئلة خلصت
        if index == currentIndex { return .current }    // الحالي
        return .idle                                     // باقي
    }
}

// MARK: - Circle State
enum CircleState {
    case idle
    case current
    case done
}

