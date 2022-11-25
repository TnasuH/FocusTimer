//
//  FocusTimerApp.swift
//  FocusTimer
//
//  Created by Tarik Nasuhoglu on 25.11.2022.
//

import SwiftUI

@main
struct FocusTimerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
