//
//  CharacterSelection.swift
//  Majlis
//
//  Created by Teif May on 14/08/1447 AH.
//

import SwiftUI

struct CharacterSelection: View {
    @State private var name: String = ""
    @State private var selectedCharacter: String? = nil
    @Namespace private var selectionNamespace

    var body: some View {
        ZStack {
            Image("backgroundT")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    TextField("اكتب اسمك هنا", text: $name)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                .frame(height: 50)
                .padding(.horizontal, 40)
                .padding(.top, 277)

                // Characters row
                HStack(spacing: 22) {
                    selectableCharacter(imageName: "Man")
                    selectableCharacter(imageName: "Woman")
                }
                .padding(.top, 44)
                .animation(.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.2), value: selectedCharacter)

                // CTA button
                Button(action: {
                    // TODO: Handle tap (e.g., navigate with selectedCharacter and name)
                }) {
                    Text("حياك الله")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.41, green: 0.28, blue: 0.20))
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                        )
                }
                .padding(.top, 44)
                .opacity(selectedCharacter == nil ? 0.6 : 1.0)
                .disabled(selectedCharacter == nil)

                Spacer()
            }
            .padding(.bottom, 48)
        }
    }

    // MARK: - Selectable Character
    @ViewBuilder
    private func selectableCharacter(imageName: String) -> some View {
        let isSelected = selectedCharacter == imageName
        let someoneSelected = selectedCharacter != nil

        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 177, height: 177)
            .scaleEffect(isSelected ? 1.12 : (someoneSelected ? 0.92 : 1.0))
            .shadow(color: isSelected ? Color.black.opacity(0.18) : Color.clear, radius: 10, x: 0, y: 6)
            .opacity(isSelected ? 1.0 : (someoneSelected ? 0.85 : 1.0))
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.2)) {
                    if selectedCharacter == imageName {
                        // Tapping the same one toggles off (optional behavior)
                        selectedCharacter = nil
                    } else {
                        selectedCharacter = imageName
                    }
                }
            }
            .scaleEffect(isSelected ? 1.0 : 1.0)
            .accessibilityAddTraits(isSelected ? [.isSelected] : [])
            .accessibilityLabel(Text(imageName == "Man" ? "رجل" : "امرأة"))
    }

    // If you want a non-tappable static option (not used now)
    @ViewBuilder
    private func characterOption(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 177, height: 177)
            .contentShape(Rectangle())
    }
}

#Preview {
    CharacterSelection()
}
