//
//  dallh.swift
//  Majlis
//
//  Created by maha althwab on 13/08/1447 AH.
//
import SwiftUI

struct CoffeeGameView: View {

    // MARK: - States
    
    @State private var fillAmount: CGFloat = 0.0
    @State private var fillTimer: Timer?
    @State private var dallahRotation: Double = 0
    
    @State private var result: ResultState = .idle
    
    let targetWidth: CGFloat = 0.33
    let coffeeOptions = ["choose", "choose", "choose"]

    var body: some View {
        ZStack {
            
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
            
            VStack {
                
                // الخيارات
                HStack(spacing: 12) {
                    ForEach(coffeeOptions.indices, id: \.self) { index in
                        Button {
                            print("Option \(index)")
                        } label: {
                            Image(coffeeOptions[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                .padding(.top, 160)
                
                Spacer()
                
                // MARK: - الفنجال + الدلة
                
                HStack(alignment: .bottom, spacing: -10) {
                    
                    // ⭐ صورة الفنجال تتغير
                    Image(currentCupImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .offset(x: 20, y: 10)
                    
                    Image("dallah")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240)
                        .rotationEffect(.degrees(dallahRotation),
                                        anchor: .topLeading)
                        .offset(x: -10, y: -5)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    tiltDallah()
                                    startFilling()
                                }
                                .onEnded { _ in
                                    resetDallah()
                                    stopFilling()
                                }
                        )
                        .animation(.easeInOut(duration: 0.25),
                                   value: dallahRotation)
                }
                
                Spacer()
                
                // MARK: - الشريط
                
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 300, height: 26)
                    
                    Capsule()
                        .fill(Color.brown.opacity(0.35))
                        .frame(width: 300 * targetWidth,
                               height: 18)
                        .padding(.leading, 4)
                    
                    Capsule()
                        .fill(progressColor)
                        .frame(
                            width: (300 - 8) * fillAmount,
                            height: 18
                        )
                        .padding(.leading, 4)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    // MARK: - الحالات
    
    enum ResultState {
        case idle
        case success
        case fail
    }
    
    // MARK: - صورة الفنجال
    
    var currentCupImage: String {
        
        if result == .fail {
            return "failcup"   // ❌ صورة الفشل
        } else {
            return "redcup"   // ☕️ الطبيعي
        }
    }
    
    // MARK: - الدلة
    
    func tiltDallah() {
        dallahRotation = -40
    }
    
    func resetDallah() {
        dallahRotation = 0
    }
    
    // MARK: - التعبئة
    
    func startFilling() {
        result = .idle   // يرجع الفنجال طبيعي
        
        guard fillTimer == nil else { return }
        
        fillTimer = Timer.scheduledTimer(
            withTimeInterval: 0.05,
            repeats: true
        ) { _ in
            
            withAnimation(.linear(duration: 0.05)) {
                
                if fillAmount < 1.0 {
                    fillAmount += 0.01
                } else {
                    fillAmount = 0.0
                }
            }
        }
    }
    
    func stopFilling() {
        fillTimer?.invalidate()
        fillTimer = nil
        
        checkResult()
    }
    
    // MARK: - التحقق
    
    func checkResult() {
        
        let tolerance: CGFloat = 0.02
        let targetEnd = targetWidth
        
        if abs(fillAmount - targetEnd) <= tolerance {
            result = .success
        }
        else if fillAmount > targetEnd {
            result = .fail   // ⭐ هنا تتغير الصورة
        }
        else {
            result = .idle
        }
    }
    
    // MARK: - لون الشريط
    
    var progressColor: Color {
        
        switch result {
            
        case .idle:
            return .yellow
            
        case .success:
            return .green
            
        case .fail:
            return .red
        }
    }
}

// Preview

struct CoffeeGameView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeGameView()
    }
}
