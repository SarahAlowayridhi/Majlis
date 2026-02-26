//
//  DallahShop.swift
//  Majlis
//
//  Created by Ruba Arif on 17/08/1447 AH.
//

import SwiftUI

struct DallahSelectionView: View {

    @ObservedObject var majlisVM: MajlisViewModel
    @State private var selectedPage = 0
    @Environment(\.dismiss) private var dismiss

    // Helper: Is the current dallah available?
    private var isSilverLocked: Bool { majlisVM.level < 3 }
    private var isSelectedLocked: Bool { selectedPage == 1 && isSilverLocked }

    // For shake animation feedback if needed
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ZStack {

            // Background
            Color(red: 0.99, green: 0.93, blue: 0.78)
                .ignoresSafeArea()

            VStack {

                // Top
                HStack {

                    // Level indicator
                    ZStack(alignment: .leading) {

                        ZStack {
                            Image("shapeb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 52, height: 36)

                            // Dynamic level from shared VM
                            Text("\(majlisVM.level)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 4)
                    }
                    .frame(width: 80, height: 34)

                    Spacer()

                    // Back button (brown) – dismiss the parent NavigationStack
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.brown)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Back")
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer(minLength: 40)

                // Quote Card
                Text("دلّع نفسك بدله تطيب الخاطر..")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: 280)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(12)

                Spacer(minLength: 20)

                // Page Indicator
                HStack(spacing: 8) {
                    Circle()
                        .fill(selectedPage == 0 ? Color.brown : Color.brown.opacity(0.3))
                        .frame(width: 8, height: 8)

                    Circle()
                        .fill(selectedPage == 1 ? Color.brown : Color.brown.opacity(0.3))
                        .frame(width: 8, height: 8)
                }

                Spacer(minLength: 20)

                // Dallah Swipe
                TabView(selection: $selectedPage) {
                    // 1. Regular Dallah
                    Image("dallah")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 220)
                        .tag(0)
                        .overlay(
                            EmptyView()
                        )
                        .accessibilityLabel("دلة عادية")

                    // 2. Silver Dallah (locked until level 3)
                    ZStack {
                        Image("silver")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220)
                            .brightness(isSilverLocked ? -0.2 : 0)
                            .opacity(isSilverLocked ? 0.6 : 1.0)
                        // Overlay lock if locked
                        if isSilverLocked {
                            Rectangle()
                                .fill(Color.black.opacity(0.34))
                                .cornerRadius(18)
                                .frame(maxWidth: 220)
                            VStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                Text("يفتح عند المستوى ٣")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.black.opacity(0.55))
                                    )
                            }
                        }
                    }
                    .tag(1)
                    .accessibilityLabel(isSilverLocked ? "دلة فضية (مقفلة حتى المستوى ٣)" : "دلة فضية")
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 280)

                Spacer()

                // Select Button
                Button(action: {
                    if isSelectedLocked {
                        // Animate shake as feedback
                        withAnimation(.default) {
                            shakeOffset = -18
                        }
                        withAnimation(Animation.default.delay(0.1)) {
                            shakeOffset = 16
                        }
                        withAnimation(Animation.default.delay(0.2)) {
                            shakeOffset = 0
                        }
                        // Optionally: add haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    } else {
                        // Perform the selection (add logic here if needed)
                        // E.g., majlisVM.selectedDallah = selectedPage
                        // Possibly dismiss or show confirmation
                    }
                }) {
                    Text("اختر")
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            isSelectedLocked ? Color.gray : Color.brown
                        )
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelectedLocked ? Color.gray.opacity(0.7) : Color.brown, lineWidth: isSelectedLocked ? 1 : 0)
                        )
                }
                .offset(x: shakeOffset)
                .disabled(isSelectedLocked)
                .opacity(isSelectedLocked ? 0.7 : 1.0)

                if isSelectedLocked {
                    Text("عليك أن تصل للمستوى ٣ لاستخدام هذه الدلة")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .transition(.opacity)
                }

                Spacer(minLength: 20)

                // Bottom Decoration
                HStack(spacing: 6) {
                    ForEach(0..<15, id: \.self) { _ in
                        DallahBottomTriangle()
                            .fill(Color.brown)
                            .frame(width: 12, height: 8)
                    }
                }
                .padding(.bottom, 12)
            }
        }
        // Hide the default system back button so only the brown one appears
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - Triangle Shape (Renamed to prevent conflict)
struct DallahBottomTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


// MARK: - Preview
#Preview {
    DallahSelectionView(majlisVM: MajlisViewModel())
}
