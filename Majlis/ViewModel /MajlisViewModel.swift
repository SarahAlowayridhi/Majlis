//
//  MajlisViewModel.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 19/08/1447 AH.
//  Updated for Region-based navigation (MVVM) by Sarah Alowayridhi
//

import SwiftUI
import Combine

@MainActor
final class MajlisViewModel: ObservableObject {

    // MARK: - Region (جديد)
    /// المنطقة اللي جاي منها المستخدم من الخريطة
    let region: Region

    // MARK: - Existing State
    @Published var name: String = ""
    @Published var selectedCharacter: CharacterType? = nil

    /// لو كنتِ تستخدمينه للتنقل من شاشة اختيار الشخصية إلى المجلس خلّيه
    @Published var goMajlis: Bool = false

    // MARK: - Init (جديد)
    /// هذا الـ init الأساسي اللي نستخدمه من MapView:
    /// Majlis(region: region) -> MajlisViewModel(region: region)
    init(region: Region) {
        self.region = region
    }

    /// هذا للـ Preview أو لو تبين Backward Compatibility (اختياري)
    convenience init() {
        self.init(region: .central)
    }

    // MARK: - Computed
    var characterImageName: String {
        selectedCharacter?.imageName ?? ""
    }

    // MARK: - Actions
    func select(_ character: CharacterType) {
        selectedCharacter = character
        goMajlis = true
    }
}

