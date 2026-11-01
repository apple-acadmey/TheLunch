import Foundation

struct QuestionProvider {

    // الاسأله
    private static let questions: [Mood: [String]] = [
        .great: [
            "What went really well for you today?",
            "Who or what made today great, and why?",
            "What achievement or progress are you proud of today?",
            "What activity gave you the most energy today?",
            "How can you celebrate or reward yourself today?",
            "What positive thought kept you going today?",
            "What is something nice someone said or did for you today?",
            "What made you smile or laugh out loud today?",
            "How can you keep this good momentum going tomorrow?",
            "What are three things you are thankful for today?",
            "What win or moment made you feel this way today, and how can you celebrate it?",
            "What is nourishing your energy right now, and how can you do more of it?"
        ],
        .good: [
            "What was a pleasant moment from your day?",
            "What habit or choice helped your day go smoothly?",
            "What task did you complete today that made you feel relieved?",
            "How did you take care of your health or well-being today?",
            "What was the most relaxing part of your day?",
            "What simple pleasure did you enjoy today?",
            "Who was pleasant or helpful to interact with today?",
            "What is something good you did for someone else today?",
            "What went according to plan today?",
            "What made today a solid, steady day?",
            "What is one small thing that went well today or brought a quiet smile to your face?",
            "Who or what brought a sense of ease or comfort into your day?"
        ],
        .unsure: [
            "What is making you feel confused or uncertain right now?",
            "What is one decision you need to make soon?",
            "What information are you missing to make a clear choice?",
            "What pros and cons are running through your mind right now?",
            "What option feels safest to you at this moment?",
            "What is the worst-case scenario, and can you handle it?",
            "What is the best possible outcome you hope for?",
            "Who can you ask for advice or guidance on this matter?",
            "What is one small action you can take to clear your head?",
            "What can you focus on today while waiting for things to clarify?",
            "If your mind or body had one sentence to tell you right now, what would it say?",
            "What is one thing that feels unclear right now, and what is a tiny step to make peace with it?"
        ],
        .low: [
            "What made you feel down or tired today?",
            "Did a specific event lower your mood, or did it happen gradually?",
            "What is draining your physical or mental energy today?",
            "What is one small thing you can do right now to rest?",
            "What responsibilities can you pause or delay until tomorrow?",
            "How does your body feel right now, and what does it need?",
            "What usually helps you feel a little better when you are low?",
            "Who is someone safe you can talk to or text right now?",
            "What comfort item or activity can you enjoy tonight?",
            "What gentle reminder do you need to hear right now?",
            "What is weighing on your heart today, and what words of kindness do you need to hear?",
            "What is one small, gentle thing you can do for yourself before the day ends?"
        ],
        .upset: [
            "What made you angry, frustrated, or upset today?",
            "Who or what triggered this strong emotion?",
            "What expectation or boundary of yours was crossed?",
            "How did you react in the moment when you felt upset?",
            "What do you need right now to calm down and reset?",
            "Is this situation something you can change, or is it out of your control?",
            "What would be the healthiest way to handle this situation?",
            "What do you need to say or communicate to resolve this?",
            "What activity can help you release this tension physically?",
            "How will this situation matter to you a week or month from now?",
            "What happened today that upset you, and how did it make you feel in your body?",
            "What is the hardest or most frustrating thing on your mind right now?"
        ]
    ]

    private static let fallback = "What would you like to reflect on today?" //لو حصل خطأ يسأل هالسوال

    ///ترجع كل اساله المود
    static func allQuestions(for mood: Mood) -> [String] {
        questions[mood] ?? [fallback]
    }

    /// A random question for the chosen mood 
    static func question(for mood: Mood) -> String {
        allQuestions(for: mood).randomElement() ?? fallback
    }

    /// Another random question for the same mood
    static func reroll(for mood: Mood, excluding current: String) -> String {
        let others = allQuestions(for: mood).filter { $0 != current }
        return others.randomElement() ?? current
    }
}
