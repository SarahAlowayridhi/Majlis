//
//  Question.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 20/08/1447 AH.
//

import Foundation

struct Answer: Identifiable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let answers: [Answer]
}
