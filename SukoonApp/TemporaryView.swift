import SwiftUI
import SwiftData

struct TemporaryView: View {
    var selectedMood: Mood
    var selectedDate: Date = Date()
    
    @State private var journalText: String = ""
    @State private var currentQuestion: String = ""
    @State private var isFavourite: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var formattedCurrentDate: String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE."
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MMM"
        
        let day = dayFormatter.string(from: selectedDate).lowercased()
        let date = dateFormatter.string(from: selectedDate)
        
        return "\(day)\n\(date)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text(formattedCurrentDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding(.horizontal, 24)
            
            HStack {
                Spacer()
                Image(selectedMood.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                Spacer()
            }
            .padding(.vertical, 8)
            
            Divider()
                .frame(width: 370)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 8) {
                Text(currentQuestion)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Temporary")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "7C4AB2"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "7C4AB2").opacity(0.30))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.horizontal, 24)
            .padding(.top, 5)
            .onAppear {
                if currentQuestion.isEmpty {
                    currentQuestion = QuestionProvider.question(for: selectedMood)
                }
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundStyle(Color.gray.opacity(0.4))
                    )
                
                if journalText.isEmpty {
                    Text("Write your reflection here...")
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                }
                
                TextEditor(text: $journalText)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(12)
            }
            .frame(minHeight: 250)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    Menu {
                        Button(action: {
                            currentQuestion = QuestionProvider.reroll(for: selectedMood, excluding: currentQuestion)
                        }) {
                            Label("Another question", systemImage: "arrow.triangle.2.circlepath")
                        }
                        
                        Button(action: {
                            isFavourite.toggle()
                        }) {
                            Label(
                                isFavourite ? "Remove favourite" : "Add favourite",
                                systemImage: isFavourite ? "star.fill" : "star"
                            )
                        }
                        .disabled(true)
                        
                        Button(role: .destructive, action: {
                            journalText = ""
                            dismiss()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primary)
                            .padding(4)
                    }

                    Button {
                        let newEntry = JournalEntryData(
                            date: selectedDate,
                            mood: selectedMood,
                            question: currentQuestion,
                            text: "",
                            isFavourite: false,
                            isTemporary: true
                        )
                        modelContext.insert(newEntry)
                        
                        journalText = ""
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .primary)
                            .padding(4)
                    }
                    .buttonStyle(.plain)
                    .disabled(journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
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
