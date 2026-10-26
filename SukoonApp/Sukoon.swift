import SwiftUI
import SwiftData

@main
struct Sukoon: App {//بنعدل عليه باسم تطبيقنا
    var body: some Scene {
        WindowGroup {
            CalendarHomeScreen()
        }
        .modelContainer(for: JournalEntryData.self)
    }
}
