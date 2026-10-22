import Foundation

// 1. تحديد أنواع المود المتاحة في التطبيق (5 مودات)
enum MoodType: String, CaseIterable {
    case great = "Great"
    case good = "Good"
    case unsure = "Unsure"
    case low = "Low"
    case upset = "Upset"
}

// 2. هيكل السؤال
struct QuestionModel: Identifiable {
    let id = UUID()
    let mood: MoodType // هنا نحدد المود التابع له السؤال
    let text: String   // نص السؤال
}

// 3. بنك الأسئلة الـ 50 (تخزين محلي أوفلاين)
class QuestionsRepository {
    static let shared = QuestionsRepository()
    
    // قائمة تجمع الـ 50 سؤالاً
    let allQuestions: [QuestionModel] = [
        // --- 1. مود Great (10 أسئلة) ---
        QuestionModel(mood: .great, text: "ما الذي جعل يومك مميزاً اليوم؟"),
        QuestionModel(mood: .great, text: "ما هي أبسط لحظة رسمت الابتسامة على وجهك؟"),
        QuestionModel(mood: .great, text: "كيف يمكنك مشاركة طاقتك الإيجابية مع من حولك؟"),
        // ... أضف بقية الـ 10 أسئلة هنا ...

        // --- 2. مود Good (10 أسئلة) ---
        QuestionModel(mood: .good, text: "ما هو الشيء اللطيف الذي حدث لك اليوم؟"),
        QuestionModel(mood: .good, text: "ما هو الهدف الصغير الذي حققته اليوم؟"),
        // ... أضف بقية الـ 10 أسئلة هنا ...

        // --- 3. مود Unsure (10 أسئلة) ---
        QuestionModel(mood: .unsure, text: "ما الذي يجعلك مشتتاً أو غير متأكد في هذه اللحظة؟"),
        QuestionModel(mood: .unsure, text: "لو أردت تبسيط أفكارك الآن، ما هي أول نقطة؟"),
        // ... أضف بقية الـ 10 أسئلة هنا ...

        // --- 4. مود Low (10 أسئلة) ---
        QuestionModel(mood: .low, text: "ما هو الشيء الذي يشغل بالك وتود تفريغه؟"),
        QuestionModel(mood: .low, text: "ما الذي تحتاج لسماعه أو الشعور به في هذه اللحظة؟"),
        // ... أضف بقية الـ 10 أسئلة هنا ...

        // --- 5. مود Upset (10 أسئلة) ---
        QuestionModel(mood: .upset, text: "اكتب كل ما يغضبك بحرية دون تجميل للأفكار."),
        QuestionModel(mood: .upset, text: "هل هذا الموقف تحت سيطرتك أم خارج عن إرادتك؟")
        // ... أضف بقية الـ 10 أسئلة هنا ...
    ]
    
    // 4. دالة فلترة الأسئلة حسب المود المختار
    func getQuestions(for selectedMood: MoodType) -> [QuestionModel] {
        return allQuestions.filter { $0.mood == selectedMood }
    }
    
    // (اختياري) دالة لاختيار سؤال واحد عشوائي من الـ 10 الخاصة بالمود
    func getRandomQuestion(for selectedMood: MoodType) -> QuestionModel? {
        return getQuestions(for: selectedMood).randomElement()
    }
}
