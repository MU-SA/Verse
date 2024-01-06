//
//  ContentView.swift
//  Verse
//
//  Created by Muhammad Saleh on 04/01/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        HomeScreen()
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
