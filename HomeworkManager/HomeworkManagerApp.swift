//
//  HomeworkManagerApp.swift
//  HomeworkManager
//
//  Created by Caleb Herrera on 12/6/2026.
//

import SwiftUI
import SwiftData

@main
struct HomeworkManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: HomeworkTask.self)
        }
    }
}
