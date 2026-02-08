import SwiftUI

struct CharacterSelection: View {

    @StateObject private var vm = MajlisViewModel()   // ✅ لازم كذا

    var body: some View {
        NavigationStack {
            ZStack {
                Image("backgroundIM")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 1) {

                    ZStack {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                        TextField("اكتب اسمك هنا", text: $vm.name) // ✅ يشتغل
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                    .padding(.top, 333)

                    Spacer()

                    HStack(spacing: 2) {

                        Button {
                            vm.select(.male)
                        } label: {
                            characterOption(imageName: "Man")
                        }

                        Button {
                            vm.select(.female)
                        } label: {
                            characterOption(imageName: "Woman")
                        }
                    }
                    .padding(.bottom, 300)
                }
            }
            .navigationDestination(isPresented: $vm.goMajlis) {
                ContentView(majlisVM: vm)
            }
        }
    }

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

