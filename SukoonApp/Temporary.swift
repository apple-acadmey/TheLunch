//
//  Temporary.swift
//  SukoonApp
//
//  Created by Raghad Alsnaie on 25/10/2026.
//

import SwiftUI

struct TemporaryView: View {
    var selectedMood: Mood
    var selectedDate: Date = Date()
    
    @State private var journalText: String = ""
    @State private var currentQuestion: String = ""
    @Environment(\.dismiss) var dismiss
    
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE."
        return formatter.string(from: selectedDate)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MMM"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black.opacity(0.7))
                        .frame(width: 44, height: 44)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
               

                Spacer()

                Button {
                    currentQuestion = QuestionProvider.reroll(for: selectedMood, excluding: currentQuestion)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black.opacity(0.7))
                        .frame(width: 44, height: 44)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            
            ZStack {
                HStack {
                    Spacer()
                    Image(selectedMood.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(dayString)
                        Text(dateString)
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black.opacity(0.5))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            
            Divider()
                .frame(width: 370)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 8) {
                Text(currentQuestion)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                
                Text("Temporary")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "7C4AB2"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "7C4AB2").opacity(0.30))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.horizontal, 20)
            .padding(.top, 5)
            .onAppear {
                if currentQuestion.isEmpty {
                    currentQuestion = QuestionProvider.question(for: selectedMood)
                }
            }

            ZStack(alignment: .topLeading) {
                if journalText.isEmpty {
                    Text("Start writing ...")
                        .foregroundStyle(.gray.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                }
                
                TextEditor(text: $journalText)
                    .scrollContentBackground(.hidden)
                    .padding(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.gray.opacity(0.4))
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double((rgbValue & 0x0000FF) >> 0) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    NavigationStack {
        TemporaryView(selectedMood: .good, selectedDate: Date())
    }
}









/*import SwiftUI

struct TemporaryView: View {
    
    
    var body: some View {
        
        VStack{
            
            HStack{
                
            }
            
            HStack{}
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    


}







#Preview {
    TemporaryView()
}*/
