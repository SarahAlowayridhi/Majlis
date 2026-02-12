//
//  QuestionsBank.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 20/08/1447 AH.
//

import Foundation

enum QuestionsBank {

    // ✅ نتركها مثل ما هي (عشان QuizViewModel ما ينكسر)
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

    // ✅ الجديد: محتوى المنطقة للجلسة (مثل + شرح + أكلة)
    static func content(for region: Region) -> RegionContent {
        switch region {

        case .western:
            return RegionContent(
                proverbQuestion: Question(
                    text: "ما أخسّ من قديد إلا ....",
                    answers: [
                        Answer(text: "عثمان", isCorrect: false),
                        Answer(text: "عسفان", isCorrect: true),
                        Answer(text: "الهدّة", isCorrect: false)
                    ]
                ),
                proverbExplanation: "قديد و عسفان قريتان قديمتان على طريق مكة والمدينة، كان يُضرب بهما المثل قديمًا بسبب سوء الطريق والمشقة.. كل وحده اسوأ من الثانيه.",
                foodQuestion: Question(
                    text: "بياض الثلج ومن الحجاز، حلوة مثل العسل، وتتزين بفستق وورد، إذا تقطّعت صارت مربعات…",
                    answers: [
                        Answer(text: "لبنيه", isCorrect: true),
                        Answer(text: "معمول", isCorrect: false),
                        Answer(text: "عصيدة", isCorrect: false)
                    ]
                )
            )

        case .eastern:
            return RegionContent(
                proverbQuestion: Question(
                    text: "سعيد أخو ...",
                    answers: [
                        Answer(text: "سعد", isCorrect: false),
                        Answer(text: "مبارك", isCorrect: true),
                        Answer(text: "ناصر", isCorrect: false)
                    ]
                ),
                proverbExplanation: "يعني شخصين متشابهين جدًا في الطبع، وغالبًا التشابه يكون في شيء غير مرغوب. ",
                foodQuestion: Question(
                    text: "أكلة من الأحساء بالذات، أساسها تمرٍ يُدعك لين يصير ناعم، ونلبّسها سمنٍ يلمع، وأحيانًا يجي معها خبز أو قهوة، وطعمها حلو ودافي ويشبّع...",
                    answers: [
                        Answer(text: "فريك", isCorrect: false),
                        Answer(text: "معصوب", isCorrect: false),
                        Answer(text: "ممروس", isCorrect: true)
                    ]
                )
            )

        case .northern:
            return RegionContent(
                proverbQuestion: Question(
                    text: "من بغى ... ما يقول اح",
                    answers: [
                        Answer(text: "النّح", isCorrect: false),
                        Answer(text: "الدّح", isCorrect: true),
                        Answer(text: "الكَرّ", isCorrect: false)
                    ]
                ),
                proverbExplanation: "فطيرة تطلع من الصاج بسرعة، ووجهها “مقشّش”، نأكلها مع عسل أو دبس تمر وأحيانًا سمن، مع القهوة في اللمة… ",
                foodQuestion: Question(
                    text: "وش الأكلة المشهورة بالمنطقة الشمالية؟",
                    answers: [
                        Answer(text: "مقشوش", isCorrect: true),
                        Answer(text: "مراصيع", isCorrect: false),
                        Answer(text: "قرصان", isCorrect: false)
                    ]
                )
            )

        case .southern:
            return RegionContent(
                proverbQuestion: Question(
                    text: "اللي ما يعرف الصقر...",
                    answers: [
                        Answer(text: "يشويه", isCorrect: true),
                        Answer(text: "يصيده", isCorrect: false),
                        Answer(text: "يخليه", isCorrect: false)
                    ]
                ),
                proverbExplanation: "يضرب لمن لا يقدر الأمور أو الأشخاص حق قدرهم، أو من يضيع الفرص الثمينة.",
                foodQuestion: Question(
                    text: "أكلة تنأكل حلوة، أسويها من عجين متوسط الاستواء وأغطّيها بالسمن والعسل، وأحيانًا أجلس جنبها رضيفه أو تمر…",
                    answers: [
                        Answer(text: "عريكه", isCorrect: true),
                        Answer(text: "معصوب", isCorrect: false),
                        Answer(text: "حنيني", isCorrect: false)
                    ]
                )
            )

        case .central:
            return RegionContent(
                proverbQuestion: Question(
                    text: "يولم العصابه قبل ...",
                    answers: [
                        Answer(text: "الضربه", isCorrect: false),
                        Answer(text: "الفلقه", isCorrect: true),
                        Answer(text: "الاصابه", isCorrect: false)
                    ]
                ),
                proverbExplanation: " يضرب للشخص الذي يستبق الأحداث قبل وقوعها.",
                foodQuestion: Question(
                    text: "دوائر عجين صغيرة على الصاج تنضج، إذا حضر العسل والسمن صارت حلوى تُفرِح، وتجي مع القشطة وأطيّب لمة الأهل…",
                    answers: [
                        Answer(text: "قرص", isCorrect: false),
                        Answer(text: "لقيمات", isCorrect: false),
                        Answer(text: "مراصيع", isCorrect: true)
                    ]
                )
            )
        }
    }

    // MARK: - Existing Questions (لا نغيّرها الآن)

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

