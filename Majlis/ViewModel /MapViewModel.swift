//
//  MapViewModel.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 20/08/1447 AH.
//

import Foundation
import Combine

@MainActor
final class MapViewModel: ObservableObject {

    /// المنطقة المختارة (نستخدمها للتنقل لشاشة الأسئلة)
    @Published var selectedRegion: Region? = nil

    /// إذا تبين تقفلين/تفتحين مناطق حسب التقدم (اختياري لاحقًا)
    @Published var unlockedRegions: Set<Region> = Set(Region.allCases)

    func select(_ region: Region) {
        guard unlockedRegions.contains(region) else { return }
        selectedRegion = region
    }

    func resetSelection() {
        selectedRegion = nil
    }
}
