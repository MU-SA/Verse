//
//  VerseApp.swift
//  Verse
//
//  Created by Muhammad Saleh on 04/01/2024.
//

import SwiftUI

@main
struct VerseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
