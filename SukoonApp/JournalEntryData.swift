import SwiftData
import Foundation

@Model
class JournalEntryData {
    var date: Date
    var moodRaw: String
    var question: String
    var text: String
    var isFavourite: Bool
    var isTemporary: Bool

    init(date: Date = .now,
             mood: Mood,
             question: String,
             text: String,
             isFavourite: Bool = false,
             isTemporary: Bool = false) {
            self.date = date
            self.moodRaw = mood.rawValue
            self.question = question
            self.text = text
            self.isFavourite = isFavourite
            self.isTemporary = isTemporary
        }

        var mood: Mood { Mood(rawValue: moodRaw) ?? .unsure }
    }
