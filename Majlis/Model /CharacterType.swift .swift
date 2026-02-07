//
//  CharacterType.swift .swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 19/08/1447 AH.
//

import Foundation

enum CharacterType: String, Codable {
    case female
    case male

    var imageName: String {
        switch self {
        case .female: return "femal"   // اسم الصورة عندك
        case .male: return "male"      // تأكدي صورة الولد اسمها male في Assets
        }
    }
}
