import SwiftUI
import SwiftData

struct TemporaryView: View {
    var selectedMood: Mood
    var selectedDate: Date          // لازم يتمرّر من MoodScaleView

    @State private var journalText: String = ""
    @State private var currentQuestion: String = ""
    @State private var isFavourite: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.closeFlow) private var closeFlow
    @Environment(\.modelContext) private var modelContext

    private var isTextEmpty: Bool {
        journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func goHome() {
        if let closeFlow {
            closeFlow()
        } else {
            dismiss()
        }
    }

    private func saveTemporary() {
        let trimmed = journalText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newEntry = JournalEntryData(
            date: selectedDate,
            mood: selectedMood,
            question: currentQuestion,
            text: trimmed,
            isFavourite: false,
            isTemporary: true
        )
        modelContext.insert(newEntry)
        try? modelContext.save()

        journalText = ""
        goHome()
    }

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
        ScrollView{
            VStack(alignment: .leading, spacing: 16) {
                
                //Text(formattedCurrentDate).font(.subheadline).foregroundColor(Color("datescolortxt")).lineSpacing(4).padding(.horizontal, 24)
                
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
                        .foregroundColor(Color("titleText"))
                    
                    Text("Temporary")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color("primarycolor"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color("primarycolor").opacity(0.30))
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
                        .fill(Color("entrybox"))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundStyle(Color("primarycolor").opacity(0.4))
                        )
                    
                    if journalText.isEmpty {
                        Text("Write your reflection here...")
                            .foregroundColor(Color("titleText").opacity(0.4))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                    }
                    
                    TextEditor(text: $journalText)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .foregroundColor(Color("titleText"))
                        .padding(12)
                }
                .frame(minHeight: 450)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                Spacer()
            }.safeAreaInset(edge: .top, alignment: .leading, spacing: 0) {
                Text(formattedCurrentDate)
                    .font(.subheadline)
                    .foregroundColor(Color("datescolortxt"))
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("background"))}
            .background(Color("background").ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("titleText"))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            currentQuestion = QuestionProvider.reroll(for: selectedMood, excluding: currentQuestion)
                        } label: {
                            Label("Another question", systemImage: "arrow.triangle.2.circlepath")
                        }
                        
                        Button {
                            isFavourite.toggle()
                        } label: {
                            Label(
                                isFavourite ? "Remove favourite" : "Add favourite",
                                systemImage: isFavourite ? "star.fill" : "star"
                            )
                        }
                        .disabled(true)
                        
                        Button(role: .destructive) {
                            journalText = ""
                            goHome()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color("titleText"))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveTemporary()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(isTextEmpty ? Color("titleText").opacity(0.3) : Color("titleText"))
                    }
                    .disabled(isTextEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TemporaryView(selectedMood: .good, selectedDate: Date())
    }
    .modelContainer(for: JournalEntryData.self, inMemory: true)
}
