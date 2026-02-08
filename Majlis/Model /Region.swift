//
//  Region.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 20/08/1447 AH.
//

import Foundation

enum Region: String, CaseIterable, Identifiable {
    case central  = "المنطقة الوسطى"
    case eastern  = "المنطقة الشرقية"
    case western  = "المنطقة الغربية"
    case northern = "المنطقة الشمالية"
    case southern = "المنطقة الجنوبية"

    var id: String { rawValue }

    // مفتاح ثابت نستخدمه للـ QuestionsBank / Assets (اختياري لكن مفيد)
    var key: String {
        switch self {
        case .central:  return "central"
        case .eastern:  return "eastern"
        case .western:  return "western"
        case .northern: return "northern"
        case .southern: return "southern"
        }
    }
}
