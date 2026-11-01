import SwiftUI
import SwiftData

@main
struct Sukoon: App {
        @AppStorage("HasSeenOnbording") var hasSeenOnboarding = false

        var body: some Scene {
            WindowGroup {
                if hasSeenOnboarding {
                    CalendarHomeScreen()
                } else {
                    onboarding(HasSeenOnbording: $hasSeenOnboarding)
                }
            }.modelContainer(for: JournalEntryData.self)
        }
    }

