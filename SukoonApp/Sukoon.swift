import SwiftUI
import SwiftData

@main
struct Sukoon: App {//بنعدل عليه باسم تطبيقنا
    var body: some Scene {
        WindowGroup {
            onboarding()
        }
        .modelContainer(for: JournalEntryData.self)
    }
}
