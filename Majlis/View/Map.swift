//
//  Map.swift
//  Majlis
//
//  Created by Ruba Arif on 17/08/1447 AH.



import SwiftUI

struct ContentView: View {

    // MARK: - ViewModel
    // هذا هو الـ ViewModel المسؤول عن اختيار المنطقة والتنقّل
    @StateObject private var viewModel = MapViewModel()
    @ObservedObject var majlisVM: MajlisViewModel
    // MARK: - UI State
    // هذا متغير خاص بالـ UI فقط (السحب بين الخرائط)
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

                        // Toggle (UI فقط – بدون منطق)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.brown, lineWidth: 2)
                                .frame(width: 80, height: 34)

                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.yellow)
                                .frame(width: 36, height: 26)
                                .padding(.leading, 4)
                        }

                        Spacer()

                        // Icons
                        HStack(spacing: 12) {
                            CircleButton(system: "gearshape.fill")
                            CircleButton(system: "storefront.circle.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Spacer(minLength: 50)

                    // MARK: - Map Swipe (Regions)
                    TabView(selection: $selectedPage) {

                        // Central
                        regionView(
                            title: "المنطقة الوسطى",
                            image: "MapCentral"
                        )
                        .tag(0)
                        .onTapGesture {
                            viewModel.select(.central)
                        }

                        // East
                        regionView(
                            title: "المنطقة الشرقية",
                            image: "MapEast"
                        )
                        .tag(1)
                        .onTapGesture {
                            viewModel.select(.eastern)
                        }

                        // South
                        regionView(
                            title: "المنطقة الجنوبية",
                            image: "MapSouth"
                        )
                        .tag(2)
                        .onTapGesture {
                            viewModel.select(.southern)
                        }

                        // West
                        regionView(
                            title: "المنطقة الغربية",
                            image: "MapWest"
                        )
                        .tag(3)
                        .onTapGesture {
                            viewModel.select(.western)
                        }

                        // North
                        regionView(
                            title: "المنطقة الشمالية",
                            image: "MapNorth"
                        )
                        .tag(4)
                        .onTapGesture {
                            viewModel.select(.northern)
                        }
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
            // MARK: - Navigation
            // أول ما تنختار منطقة من الـ ViewModel ننتقل لشاشة Majlis
            .navigationDestination(item: $viewModel.selectedRegion) { region in
                Majlis(viewModel: majlisVM, region: region)
            }
        }
    }

    // هذا مجرد View لتقليل التكرار
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
struct CircleButton: View {
    var system: String

    var body: some View {
        Button(action: {}) {
            Image(systemName: system)
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(Color.brown))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
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
    let vm = MajlisViewModel()
    vm.selectedCharacter = .female  // اختياري عشان تشوفين الشخصية
    return ContentView(majlisVM: vm)
}


