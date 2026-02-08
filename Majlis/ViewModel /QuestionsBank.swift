//
//  QuestionsBank.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 20/08/1447 AH.
//

import Foundation

enum QuestionsBank {

    static func questions(for region: Region) -> [Question] {
        switch region {
        case .western:
            return westernQuestions()
        case .eastern:
            return easternQuestions()
        case .northern:
            return northernQuestions()
        case .southern:
            return southernQuestions()
        case .central:
            return centralQuestions()
        }
    }

    private static func westernQuestions() -> [Question] {
        [
            Question(
                text: "عندي مثل وقصه، ومنها أخذ العبره.",
                answers: [
                    Answer(text: "عثمان", isCorrect: false),
                    Answer(text: "لبينه", isCorrect: true),
                    Answer(text: "سلمان", isCorrect: false)
                ]
            )
        ]
    }

    private static func easternQuestions() -> [Question] {
        [
            Question(
                text: "سعيد أخو ...",
                answers: [
                    Answer(text: "سعد", isCorrect: true),
                    Answer(text: "مبارك", isCorrect: false),
                    Answer(text: "ناصر", isCorrect: false)
                ]
            )
        ]
    }

    private static func northernQuestions() -> [Question] {
        [
            Question(
                text: "من بغى ... ما يقول اح",
                answers: [
                    Answer(text: "الدح", isCorrect: true),
                    Answer(text: "المشقش", isCorrect: false),
                    Answer(text: "التمر", isCorrect: false)
                ]
            )
        ]
    }

    private static func southernQuestions() -> [Question] {
        [
            Question(
                text: "اللي ما يعرف الصقر...",
                answers: [
                    Answer(text: "يشويه", isCorrect: true),
                    Answer(text: "يعلفه", isCorrect: false),
                    Answer(text: "يبيعه", isCorrect: false)
                ]
            )
        ]
    }

    private static func centralQuestions() -> [Question] {
        [
            Question(
                text: "يولم العصابه قبل ...",
                answers: [
                    Answer(text: "الطلقة", isCorrect: true),
                    Answer(text: "الجمعة", isCorrect: false),
                    Answer(text: "الوقعة", isCorrect: false)
                ]
            )
        ]
    }
}
