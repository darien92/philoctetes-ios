//
//  PhilApp.swift
//  Phil
//
//  Created by Darién on 2/27/26.
//

import SwiftUI
import CoreData

@main
struct PhilApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
