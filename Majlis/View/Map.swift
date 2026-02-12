//
//  Map.swift
//  Map
//
//  Created by Ruba Arif on 17/08/1447 AH.
//

import SwiftUI

struct ContentView: View {

    // MARK: - ViewModel
    @StateObject private var viewModel = MapViewModel()

    /// هذا VM جاينا من اختيار الشخصية (يحمل selectedCharacter + name)
    @ObservedObject var majlisVM: MajlisViewModel

    // MARK: - UI State
    @State private var selectedPage = 0

    var body: some View {
        NavigationStack {
            ZStack {

                // Background
                Color(red: 0.99, green: 0.93, blue: 0.78)
                    .ignoresSafeArea()

                VStack {

                    // MARK: - Top Controls
                    HStack {

                        // MARK: Level Indicator (shapeb + number)
                        ZStack {
                            Image("shapeb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)

                            // Dynamic level from shared VM
                            Text("\(majlisVM.level)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }

                        Spacer()

                        // MARK: - Icons (Settings & Store)
                        HStack(spacing: 12) {
                            
                            // زر الإعدادات
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color.brown))
                            }
                            .buttonStyle(PlainButtonStyle())

                            // زر المتجر - Navigation to Dallah Selection
                            NavigationLink(destination: DallahSelectionView(majlisVM: majlisVM)) {
                                Image(systemName: "storefront.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color.brown))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Spacer(minLength: 50)

                    // MARK: - Map Swipe (Regions)
                    TabView(selection: $selectedPage) {

                        regionView(title: "المنطقة الوسطى", image: "MapCentral")
                            .tag(0)
                            .onTapGesture { viewModel.select(.central) }

                        regionView(title: "المنطقة الشرقية", image: "MapEast")
                            .tag(1)
                            .onTapGesture { viewModel.select(.eastern) }

                        regionView(title: "المنطقة الجنوبية", image: "MapSouth")
                            .tag(2)
                            .onTapGesture { viewModel.select(.southern) }

                        regionView(title: "المنطقة الغربية", image: "MapWest")
                            .tag(3)
                            .onTapGesture { viewModel.select(.western) }

                        regionView(title: "المنطقة الشمالية", image: "MapNorth")
                            .tag(4)
                            .onTapGesture { viewModel.select(.northern) }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 380)

                    // MARK: - Swipe Indicator Dots
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { index in
                            Circle()
                                .fill(
                                    selectedPage == index
                                    ? Color.brown
                                    : Color.brown.opacity(0.3)
                                )
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8)

                    Spacer()

                    // MARK: - Bottom Decoration
                    HStack(spacing: 6) {
                        ForEach(0..<15, id: \.self) { _ in
                            BottomTriangle()
                                .fill(Color.brown)
                                .frame(width: 12, height: 8)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
            // MARK: - Navigation for Regions
            .navigationDestination(item: $viewModel.selectedRegion) { region in

                let sessionVM = MajlisViewModel(region: region)

                sessionVM.name = majlisVM.name
                sessionVM.selectedCharacter = majlisVM.selectedCharacter

                return Majlis(viewModel: sessionVM, region: region)
            }
        }
    }

    // MARK: - Region View
    private func regionView(title: String, image: String) -> some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.title3)
                .foregroundColor(.black)

            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
        }
    }
}

// MARK: - Bottom Triangle Shape
struct BottomTriangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    let vm = MajlisViewModel(region: .central)
    vm.selectedCharacter = .female
    return ContentView(majlisVM: vm)
}

