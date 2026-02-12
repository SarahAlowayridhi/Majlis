//
//  CharacterSelection.swift
//  Majlis
//
//  Created by Teif May on 14/08/1447 AH.
//

import SwiftUI

struct CharacterSelection: View {
    @ObservedObject var viewModel: MajlisViewModel

    @State private var selectedCharacter: CharacterType? = nil
    @Namespace private var selectionNamespace
    @State private var goNext: Bool = false

    private var trimmedName: String {
        viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canProceed: Bool {
        !trimmedName.isEmpty && selectedCharacter != nil
    }

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

                    ZStack {
                        TextField("", text: $viewModel.name)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)

                        if viewModel.name.isEmpty {
                            Text("اكتب اسمك هنا")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(Color.black.opacity(0.33)) // darker placeholder
                                .padding(.horizontal, 20)
                                .allowsHitTesting(false) // taps go to the TextField
                        }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 40)
                .padding(.top, 277)

                HStack(spacing: 22) {
                    selectableCharacter(imageName: "Man", type: .male)
                    selectableCharacter(imageName: "Woman", type: .female)
                }
                .padding(.top, 44)
                .animation(.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.2), value: selectedCharacter)

                Button(action: {
                    guard canProceed, let chosen = selectedCharacter else { return }
                    viewModel.persistProfile(name: trimmedName, character: chosen)
                    viewModel.selectedCharacter = chosen
                    goNext = true
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
                .opacity(canProceed ? 1.0 : 0.6)
                .disabled(!canProceed)
                .buttonStyle(.plain)

                if trimmedName.isEmpty {
                    Text("اكتب اسمك لاهنت")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(red: 0.62, green: 0.20, blue: 0.16))
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding(.bottom, 48)
        }
        .background(
            NavigationLink(isActive: $goNext) {
                Group {
                    if selectedCharacter == .male {
                        ManStory(name: trimmedName, viewModel: viewModel)
                            .navigationBarBackButtonHidden(true)
                    } else if selectedCharacter == .female {
                        WomanStory(name: trimmedName, viewModel: viewModel)
                            .navigationBarBackButtonHidden(true)
                    } else {
                        EmptyView()
                    }
                }
            } label: { EmptyView() }
                .hidden()
        )
        .onAppear {
            viewModel.loadPersistedProfile()
            if let existing = viewModel.selectedCharacter {
                selectedCharacter = existing
            }
        }
    }

    // MARK: - Selectable Character
    @ViewBuilder
    private func selectableCharacter(imageName: String, type: CharacterType) -> some View {
        let isSelected = selectedCharacter == type
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
                    if selectedCharacter == type {
                        selectedCharacter = nil
                    } else {
                        selectedCharacter = type
                    }
                }
            }
            .accessibilityAddTraits(isSelected ? [.isSelected] : [])
            .accessibilityLabel(Text(type == .male ? "رجل" : "امرأة"))
    }

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
    NavigationStack {
        CharacterSelection(viewModel: MajlisViewModel())
    }
}
