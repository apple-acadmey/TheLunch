import SwiftUI

// MARK: - Journal Reflection Page View
struct ReflectionPageView: View {
    // Passed dynamically from MoodScaleView (no default value)
    var selectedMood: Mood
    
    @State private var currentQuestion: String = ""
    @State private var userReflectionText: String = ""
    @State private var isFavourite: Bool = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
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
            // Back Button -> Pops back to MoodScaleView
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
            
            // Three Dots (...) Options Menu
            ToolbarItem(placement: .navigationBarTrailing) {
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
                    
                    Button(role: .destructive, action: {
                        userReflectionText = ""
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                        .padding(8)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ReflectionPageView(selectedMood: .good)
    }
}
