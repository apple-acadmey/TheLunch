import SwiftUI
import SwiftData

// MARK: - Close Flow (يقفل كل الصفحات ويرجع للهوم)

private struct CloseFlowKey: EnvironmentKey {
    static var defaultValue: (() -> Void)? { nil }
}

extension EnvironmentValues {
    /// Set this from the home screen on the sheet content.
    /// Calling it closes the whole add-entry flow.
    var closeFlow: (() -> Void)? {
        get { self[CloseFlowKey.self] }
        set { self[CloseFlowKey.self] = newValue }
    }
}

// MARK: - Entry Date (اليوم اللي ضغط عليه اليوزر في الهوم)

private struct EntryDateKey: EnvironmentKey {
    static var defaultValue: Date { .now }
}

extension EnvironmentValues {
    /// Set from the home screen. Defaults to today if nothing is set.
    var entryDate: Date {
        get { self[EntryDateKey.self] }
        set { self[EntryDateKey.self] = newValue }
    }
}

// MARK: - Journal Reflection Page View

struct ReflectionPageView: View {
    // Passed dynamically from MoodScaleView (no default value)
    var selectedMood: Mood

    // Optional: the pressed day. If nil, the day from the environment (entryDate) is used.
    var date: Date? = nil

    // Optional: only needed if an entry was already created before this screen
    var existingEntry: JournalEntryData? = nil

    // Optional: still supported, but not needed if the home screen sets closeFlow
    var onDelete: (() -> Void)? = nil

    @State private var currentQuestion: String = ""
    @State private var userReflectionText: String = ""
    @State private var isFavourite: Bool = false
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.closeFlow) private var closeFlow
    @Environment(\.entryDate) private var entryDate
    @Environment(\.modelContext) private var context // للحفظ

    // The date shown on top and saved with the entry
    private var displayDate: Date {
        existingEntry?.date ?? date ?? entryDate
    }

    // MARK: - Go Home

    private func goHome() {
        if let onDelete {
            onDelete()
        } else if let closeFlow {
            closeFlow()   // يقفل كل الصفحات ويرجع للهوم
        } else {
            dismiss()     // fallback: one step back
        }
    }

    // MARK: - Save

    private func saveEntry() {
        let trimmed = userReflectionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return } // ما نحفظ لو فاضي

        if let entry = existingEntry {
            entry.question = currentQuestion
            entry.text = trimmed
            entry.isFavourite = isFavourite
            entry.isTemporary = false
        } else {
            let entry = JournalEntryData(
                date: displayDate,   // اليوم اللي ضغط عليه اليوزر
                mood: selectedMood,
                question: currentQuestion,
                text: trimmed,
                isFavourite: isFavourite,
                isTemporary: false
            )
            context.insert(entry)
        }

        try? context.save()
        goHome()
    } // func of saving entry

    // MARK: - Delete

    private func discardEntry() {
        // امسح كل البيانات
        userReflectionText = ""
        isFavourite = false
        currentQuestion = ""
        isFocused = false

        // لو فيه entry محفوظ مسبقاً نحذفه من SwiftData
        if let entry = existingEntry {
            context.delete(entry)
            try? context.save()
        }

        goHome()
    }

    // MARK: - Date

    private var formattedCurrentDate: String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE."

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MMM"

        let day = dayFormatter.string(from: displayDate).lowercased()
        let dateText = dateFormatter.string(from: displayDate)

        return "\(day)\n\(dateText)"
    }

    // MARK: - Body

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
            if let entry = existingEntry {
                if currentQuestion.isEmpty { currentQuestion = entry.question }
                if userReflectionText.isEmpty { userReflectionText = entry.text }
                isFavourite = entry.isFavourite
            } else if currentQuestion.isEmpty {
                currentQuestion = QuestionProvider.question(for: selectedMood)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // الرجوع (خطوة وحدة للخلف)
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }

            // الثلاث نقاط
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

                    // الحذف: يمسح كل البيانات ويرجع للصفحة الرئيسية
                    Button(role: .destructive) {
                        discardEntry()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                } label: {
                    Image(systemName: "ellipsis")
                }
            }

            // الصح
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveEntry()
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(userReflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .tint(.black)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ReflectionPageView(selectedMood: .good)
    }
    .modelContainer(for: JournalEntryData.self, inMemory: true)
}
