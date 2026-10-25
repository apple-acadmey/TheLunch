import SwiftUI
import SwiftData
// MARK: - Journal Reflection Page View


struct ReflectionPageView: View {
    // Passed dynamically from MoodScaleView (no default value)
    var selectedMood: Mood
    
    @State private var currentQuestion: String = ""
    @State private var userReflectionText: String = ""
    @State private var isFavourite: Bool = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context //للحفظ
    
    private func saveEntry() {
        let trimmed = userReflectionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }// ما نحفظ لو فاضي

        let entry = JournalEntryData(
            mood: selectedMood,
            question: currentQuestion,
            text: trimmed,
            isFavourite: isFavourite
        )
        context.insert(entry)
        try? context.save()
        dismiss()
    }//func of saving entry
    private var formattedCurrentDate: String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE."
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MMM"
        
        let day = dayFormatter.string(from: Date()).lowercased()
        let date = dateFormatter.string(from: Date())
        
        return "\(day)\n\(date)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Two-Line Date Header
            Text(formattedCurrentDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding(.horizontal, 24)
            
            // Mood Asset Image selected by user
            HStack {
                Spacer()
                Image(selectedMood.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                Spacer()
            }
            .padding(.vertical, 8)
            
            // Question for Selected Mood
            Text(currentQuestion)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
            
            // User Reflection Text Box
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                
                if userReflectionText.isEmpty {
                    Text("Write your reflection here...")
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                }
                
                TextEditor(text: $userReflectionText)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(12)
                    .focused($isFocused)
            }
            .frame(minHeight: 250)
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .onAppear {
            if currentQuestion.isEmpty {
                currentQuestion = QuestionProvider.question(for: selectedMood)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            // الرجوع
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black.opacity(0.60))
                        .frame(width: 40, height: 40)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            // النقاط
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    // ... عناصر القائمة
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black.opacity(0.60))
                        .frame(width: 40, height: 40)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .sharedBackgroundVisibility(.hidden)   // ← بعد قوس ToolbarItem

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveEntry()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black.opacity(0.60))
                        .frame(width: 40, height: 40)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .disabled(userReflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .sharedBackgroundVisibility(.hidden)   // ← نفس الشي

            // الصح
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveEntry()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black.opacity(0.60))
                        .frame(width: 40, height: 40)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .disabled(userReflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .tint(Color("primarycolor").opacity(0.9))}
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ReflectionPageView(selectedMood: .good)
    }
}
