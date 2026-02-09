//
//  CoffeeData.swift
//  Majlis
//
//  Created by maha althwab on 21/08/1447 AH.
//
import Foundation

// MARK: - Model

struct CoffeeOption: Identifiable {

    var id: String { text }   // ⭐ ثابت

    let text: String
    let isCorrect: Bool
}

struct CoffeeData {

    static func options(for region: Region) -> [CoffeeOption] {

        switch region {

        // المنطقة الوسطى
        case .central:
            return [
                CoffeeOption(text: "زعفران", isCorrect: true),
                CoffeeOption(text: "هيل",     isCorrect: true),
                CoffeeOption(text: "زنجبيل", isCorrect: false)
            ]

        // الغربية
        case .western:
            return [
                CoffeeOption(text: "هيل",     isCorrect: true),
                CoffeeOption(text: "مستكة",   isCorrect: true),
                CoffeeOption(text: "زنجبيل", isCorrect: false)
            ]

        // الجنوبية
        case .southern:
            return [
                CoffeeOption(text: "زنجبيل", isCorrect: true),
                CoffeeOption(text: "هيل",     isCorrect: true),
                CoffeeOption(text: "نخوة",    isCorrect: true)
            ]

        // الشرقية
        case .eastern:
            return [
                CoffeeOption(text: "هيل",     isCorrect: true),
                CoffeeOption(text: "زعفران", isCorrect: true),
                CoffeeOption(text: "مستكة",   isCorrect: false)
            ]

        // الشمالية
        case .northern:
            return [
                CoffeeOption(text: "هيل",     isCorrect: true),
                CoffeeOption(text: "مستكة",   isCorrect: false),
                CoffeeOption(text: "زنجبيل", isCorrect: false)
            ]
        }
    }
}
