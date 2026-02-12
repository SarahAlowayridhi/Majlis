//
//  MajlisViewModel.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 19/08/1447 AH.
//  Updated for Session Flow (MVVM) by Sarah Alowayridhi
//

import SwiftUI
import Combine

@MainActor
final class MajlisViewModel: ObservableObject {

    // MARK: - Region
    let region: Region

    // ✅ محتوى المنطقة (مثل + شرح + أكلة)
    private let content: RegionContent

    // MARK: - Profile State
    @Published var name: String = ""
    @Published var selectedCharacter: CharacterType? = nil
    @Published var goMajlis: Bool = false

    // MARK: - Persistence Keys
    @AppStorage("onboardingCompleted") private var onboardingCompleted: Bool = false
    @AppStorage("userName") private var storedName: String = ""
    @AppStorage("selectedCharacterRawValue") private var storedCharacterRaw: String = ""

    // MARK: - Session Flow
    enum Step: Equatable {
        case coffeeHintChoices
        case datesQuestion
        case incenseQuestion
        case staticStartPage
        case proverbQuestion
        case proverbExplanation
        case foodQuestion
        case finished
    }

    @Published var step: Step = .coffeeHintChoices
    @Published var xp: Int = 0
    @Published var showCoffeeGame: Bool = false
    @Published var selectedAnswerID: UUID? = nil
    @Published var selectedIconKey: String? = nil

    // ✅ NEW: Result counting (بدل XP في شاشة النهاية)
    @Published private(set) var correctCount: Int = 0
    @Published private(set) var totalCount: Int = 0

    var didAnswerAllCorrect: Bool {
        totalCount > 0 && correctCount == totalCount
    }
    var progressTotal: Int { 4 }

    var progressCurrent: Int { min(correctCount, progressTotal) }

    // MARK: - Data Sources
    private let proverbQuestionInternal: Question

    private var proverbExplanationText: String {
        content.proverbExplanation
    }

    private var foodQuestionInternal: Question {
        content.foodQuestion
    }

    // MARK: - Init
    init(region: Region) {
        self.region = region
        self.content = QuestionsBank.content(for: region)
        self.proverbQuestionInternal = self.content.proverbQuestion

        // Load persisted profile if available
        loadPersistedProfile()
    }

    /// للـ Preview فقط
    convenience init() {
        self.init(region: .central)
    }

    // MARK: - Profile Persistence
    func loadPersistedProfile() {
        // Name
        if !storedName.isEmpty {
            name = storedName
        }
        // Character
        if let c = CharacterType(rawValue: storedCharacterRaw) {
            selectedCharacter = c
        }
    }

    func persistProfile(name: String, character: CharacterType) {
        storedName = name
        storedCharacterRaw = character.rawValue
        self.name = name
        self.selectedCharacter = character
    }

    func markOnboardingCompleted() {
        onboardingCompleted = true
    }

    var isOnboardingCompleted: Bool { onboardingCompleted }

    // MARK: - Computed
    var characterImageName: String {
        selectedCharacter?.imageName ?? ""
    }

    var cardText: String {
        switch step {
        case .coffeeHintChoices:
            return "يا محلى الفنجان مع سبحة البال\nفي مجلس ما فيه نفس ثقيله.."
        case .datesQuestion:
            return "يا زين هالتميرات.."
        case .incenseQuestion:
            return "زانت بكم وبطيبكم..\nبعد العود.. ما من قعود"
        case .staticStartPage:
            return "عندي مَثل وقصه.. ومنها ناخذ العبره.."
        case .proverbQuestion:
            return proverbQuestionInternal.text
        case .proverbExplanation:
            return proverbExplanationText
        case .foodQuestion:
            return foodQuestionInternal.text
        case .finished:
            // ✅ ما عاد نعرض "خلصنا / XP" هنا
            return ""
        }
    }

    var proverbQuestion: Question? { proverbQuestionInternal }
    var foodQuestion: Question { foodQuestionInternal }

    // MARK: - Actions (Profile)
    func select(_ character: CharacterType) {
        selectedCharacter = character
        goMajlis = true
    }

    // MARK: - Actions (Session)
    func restartSession() {
        xp = 0
        selectedAnswerID = nil
        selectedIconKey = nil
        showCoffeeGame = false

        // ✅ reset result counters
        correctCount = 0
        totalCount = 0

        step = .coffeeHintChoices
    }

    func tapDallahToOpenCoffeeGame() {
        showCoffeeGame = true
    }

    func coffeeGameFinishedSuccessfully() {
        showCoffeeGame = false
        selectedIconKey = nil
        step = .datesQuestion
    }

    func answerDates(iconKey: String, isCorrect: Bool) {
        guard selectedIconKey == nil else { return }
        selectedIconKey = iconKey

        // XP (لو تبينه يبقى للتقدم)
        if isCorrect { xp += 1 }

        // ✅ counting
        totalCount += 1
        if isCorrect { correctCount += 1 }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.selectedIconKey = nil
            self.step = .incenseQuestion
        }
    }

    func answerIncense(iconKey: String, isCorrect: Bool) {
        guard selectedIconKey == nil else { return }
        selectedIconKey = iconKey

        if isCorrect { xp += 1 }

        // ✅ counting
        totalCount += 1
        if isCorrect { correctCount += 1 }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.selectedIconKey = nil
            self.step = .staticStartPage
        }
    }

    func tapStart() {
        selectedAnswerID = nil
        step = .proverbQuestion
    }

    func chooseProverbAnswer(_ answer: Answer) {
        guard selectedAnswerID == nil else { return }
        selectedAnswerID = answer.id

        if answer.isCorrect { xp += 1 }

        // ✅ counting
        totalCount += 1
        if answer.isCorrect { correctCount += 1 }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.selectedAnswerID = nil
            self.step = .proverbExplanation
        }
    }

    func goToFoodQuestion() {
        selectedAnswerID = nil
        step = .foodQuestion
    }

    func chooseFoodAnswer(_ answer: Answer) {
        guard selectedAnswerID == nil else { return }
        selectedAnswerID = answer.id

        if answer.isCorrect { xp += 1 }

        // ✅ counting
        totalCount += 1
        if answer.isCorrect { correctCount += 1 }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.selectedAnswerID = nil
            self.step = .finished
        }
    }

    func circleState(for answer: Answer) -> AnswerCircleState {
        // قبل الاختيار: كلها idle
        guard let selected = selectedAnswerID else { return .idle }

        // بعد الاختيار: نبين الصحيح دائمًا أخضر
        if answer.isCorrect { return .correct }

        // إذا هذي هي اللي ضغطها وكانت غلط: أحمر
        if answer.id == selected { return .wrong }

        // باقي الخيارات
        return .idle
    }
}

