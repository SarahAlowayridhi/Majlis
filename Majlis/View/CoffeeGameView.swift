//
//  dallh.swift
//  Majlis
//
//  Created by maha althwab on 13/08/1447 AH.
//

import SwiftUI

struct CoffeeGameView: View {
    // حالات اللعبة
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var attempts = 0
    @State private var gameFinished = false
    @State private var selectedIngredient = ""
    
    // الإجابة الصحيحة
    private let correctAnswer = "زنجبيل"
    
    // بيانات المكونات
    private let ingredients = [
        ("زنجبيل", "leaf.fill", Color.green),
        ("هيل", "seal.fill", Color.orange),
        ("زعفران", "sparkles", Color.yellow)
    ]
    
    // رسائل النتائج
    private let correctMessages = [
        "أحسنت! الإجابة صحيحة 🎉",
        "ممتاز! لقد اخترت المكون الصحيح ✅",
        "برافو! هذه هي الإجابة الصحيحة 👏"
    ]
    
    private let wrongMessages = [
        "آسف، الإجابة خاطئة ❌",
        "ليس هذا المكون المطلوب 😔",
        "جرب مرة أخرى، هذه الإجابة غير صحيحة ✋"
    ]
    
    var body: some View {
        ZStack {
            // الخلفية
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.95, green: 0.92, blue: 0.85), Color(red: 0.85, green: 0.75, blue: 0.65)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // العنوان
                Text("لعبة الدلة والفنجان")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                    .padding(.top)
                
                // التعليمات
                VStack(alignment: .leading, spacing: 8) {
                    Text("التعليمات:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                    
                    Text("اختر المكون الصحيح الذي يجب إضافته للقهوة حسب النص")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("تلميح: النص يشير إلى أن إضافة الزنجبيل يجعل الدلة تتصفر")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.15))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 0.95, green: 0.90, blue: 0.85))
                )
                .padding(.horizontal)
                
                // منطقة الصور
                HStack(spacing: 40) {
                    VStack {
                        // صورة الدلة
                        Image(systemName: "mug.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 150)
                            .foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.15))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        
                        Text("دلة القهوة")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                            .fontWeight(.medium)
                    }
                    
                    VStack {
                        // صورة الفنجال
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(red: 0.45, green: 0.30, blue: 0.20))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        
                        Text("فنجال القهوة")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                            .fontWeight(.medium)
                    }
                }
                .padding(.vertical)
                
                // نص اللعبة من الصورة الأصلية
                VStack(spacing: 10) {
                    Text("نص اللعبة:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                    
                    Text("اذا تعدا الحد تتصفر الدله")
                        .font(.body)
                        .foregroundColor(.brown)
                    
                    Text("ز عشان يجرب مع مؤثر صوب")
                        .font(.body)
                        .foregroundColor(.brown)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.brown, lineWidth: 2)
                        .background(Color.white.opacity(0.8))
                )
                .cornerRadius(15)
                .padding(.horizontal)
                
                // أزرار المكونات
                Text("اختر المكون الصحيح:")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                
                ForEach(ingredients, id: \.0) { ingredient in
                    Button(action: {
                        checkAnswer(selected: ingredient.0)
                    }) {
                        HStack {
                            Image(systemName: ingredient.1)
                                .font(.title2)
                            
                            Text(ingredient.0)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(getButtonColor(for: ingredient.0))
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .disabled(gameFinished && ingredient.0 != correctAnswer)
                    .padding(.horizontal)
                }
                
                // عرض النتيجة
                if showResult {
                    VStack(spacing: 10) {
                        Text(isCorrect ? correctMessages.randomElement()! : wrongMessages.randomElement()!)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .red)
                            .multilineTextAlignment(.center)
                        
                        if isCorrect {
                            Text("زنجبيل هو المكون الصحيح الذي يجب إضافته للقهوة حسب النص العربي")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.9))
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                // عدد المحاولات
                Text("عدد المحاولات: \(attempts)")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.36, green: 0.25, blue: 0.20))
                    .padding(.top)
                
                // زر إعادة اللعبة
                if gameFinished {
                    Button(action: resetGame) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("إعادة اللعبة")
                        }
                        .font(.headline)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.36, green: 0.25, blue: 0.20))
                        )
                        .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // دالة للتحقق من الإجابة
    private func checkAnswer(selected: String) {
        if gameFinished { return }
        
        attempts += 1
        selectedIngredient = selected
        isCorrect = (selected == correctAnswer)
        showResult = true
        
        if isCorrect {
            gameFinished = true
        }
        
        // إخفاء النتيجة بعد 3 ثواني إذا كانت خاطئة
        if !isCorrect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showResult = false
                }
            }
        }
    }
    
    // دالة لإعادة اللعبة
    private func resetGame() {
        withAnimation {
            attempts = 0
            gameFinished = false
            showResult = false
            selectedIngredient = ""
        }
    }
    
    // دالة لتحديد لون الزر
    private func getButtonColor(for ingredient: String) -> Color {
        if !gameFinished {
            return Color(red: 0.55, green: 0.35, blue: 0.15)
        }
        
        if ingredient == correctAnswer {
            return .green
        } else if ingredient == selectedIngredient {
            return .red
        } else {
            return Color.gray.opacity(0.5)
        }
    }
}

// عرض معاينة للعبة
struct CoffeeGameView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeGameView()
    }
}
