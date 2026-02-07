//
//  MajlisViewModel.swift.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 19/08/1447 AH.
//

import SwiftUI
import Combine

final class MajlisViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedCharacter: CharacterType? = nil
    @Published var goMajlis: Bool = false

    var characterImageName: String {
        selectedCharacter?.imageName ?? ""
    }

    func select(_ character: CharacterType) {
        selectedCharacter = character
        goMajlis = true
    }
}


