//
//  WomanStory.swift
//  Majlis
//
//  Created by Teif May on 20/08/1447 AH.
//

import SwiftUI

struct WomanStory: View {
    var name: String
    @ObservedObject var viewModel: MajlisViewModel
    @State private var goMap: Bool = false

    var onSkip: (() -> Void)? = nil
    var onFinish: (() -> Void)? = nil

    @State private var index: Int = 0
    @State private var showCaption: Bool = true
    @State private var isDragging: Bool = false

    private struct Page: Identifiable, Equatable {
        let id = UUID()
        let imageName: String
        let caption: String
        let showsPrimaryCTA: Bool
    }

    private var pages: [Page] {
        [
            Page(imageName: "WomanStory1",
                 caption: "\(name) تعلّمت السنع من امها",
                 showsPrimaryCTA: false),
            Page(imageName: "WomanStory2",
                 caption: "المجلس أمانة عندك يا \(name)",
                 showsPrimaryCTA: false),
            Page(imageName: "WomanStory3",
                 caption: "هل انتي جاهزه للتحدي؟",
                 showsPrimaryCTA: true)
        ]
    }

    private var isLast: Bool { index == pages.count - 1 }
    private var isFirst: Bool { index == 0 }

    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                Spacer(minLength: 0)

                ZStack {
                    storyImage(pages[index].imageName)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.98)),
                                                removal: .opacity))
                        .id(pages[index].id)
                        .gesture(dragGesture)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                captionArea

                progressDots
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                controlsBar
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: index)
        }
        .onChange(of: index) { _, _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                showCaption = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    showCaption = true
                }
            }
        }
        .background(
            NavigationLink(isActive: $goMap) {
                ContentView(majlisVM: viewModel)
                    .navigationBarBackButtonHidden(true)
            } label: { EmptyView() }
                .hidden()
        )
    }

    private var topBar: some View {
        HStack {
            Button(action: {
                viewModel.markOnboardingCompleted()
                goMap = true
                onSkip?()
            }) {
                Text("تخطي")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.35))
                    )
            }
            .buttonStyle(.plain)
            .padding(.leading, 16)
            .padding(.top, 8)

            Spacer()
        }
    }

    @ViewBuilder
    private func storyImage(_ name: String) -> some View {
        GeometryReader { geo in
            let safeInset = geo.safeAreaInsets
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: min(geo.size.width, 500))
                .padding(.top, max(8, safeInset.top * 0.2))
                .padding(.horizontal, 16)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }

    @ViewBuilder
    private var captionArea: some View {
        if !pages[index].caption.isEmpty {
            Text(pages[index].caption)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 40)
                .padding(.top, 8)
                .opacity(showCaption ? 1 : 0)
                .offset(y: showCaption ? 0 : 8)
        } else {
            Spacer().frame(height: 12)
        }
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { i in
                Circle()
                    .fill(i == index ? Color("Color 2") : Color.black.opacity(0.2))
                    .frame(width: i == index ? 10 : 7, height: i == index ? 10 : 7)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: index)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("التقدم")
        .accessibilityValue("\(index + 1) من \(pages.count)")
    }

    private var controlsBar: some View {
        HStack(spacing: 12) {
            Button(action: goBack) {
                controlPill(icon: "chevron.left", flipped: true, label: "رجوع")
            }
            .disabled(isFirst)
            .opacity(isFirst ? 0.5 : 1)

            Spacer()

            if isLast {
                Button(action: {
                    viewModel.markOnboardingCompleted()
                    goMap = true
                    onFinish?()
                }) {
                    HStack(spacing: 10) {
                        Text("جاهز!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Image(systemName: "hand.tap")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.62, green: 0.20, blue: 0.16))
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("جاهز للبدء")
            } else {
                Button(action: goForward) {
                    controlPill(icon: "chevron.right", flipped: false, label: "التالي")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 18)
    }

    @ViewBuilder
    private func controlPill(icon: String, flipped: Bool, label: String) -> some View {
        HStack(spacing: 8) {
            if flipped {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            } else {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.35))
        )
        .contentShape(Rectangle())
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 15, coordinateSpace: .local)
            .onChanged { _ in
                if !isDragging {
                    isDragging = true
                }
            }
            .onEnded { value in
                defer { isDragging = false }
                let threshold: CGFloat = 40
                if value.translation.width < -threshold {
                    goForward()
                } else if value.translation.width > threshold {
                    goBack()
                }
            }
    }

    private func goForward() {
        guard index < pages.count - 1 else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        index += 1
    }

    private func goBack() {
        guard index > 0 else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        index -= 1
    }
}

#Preview {
    NavigationStack {
        WomanStory(name: "نورة", viewModel: MajlisViewModel())
            .navigationBarBackButtonHidden(true)
    }
}
