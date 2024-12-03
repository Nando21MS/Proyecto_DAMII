//
//  ToDoSwiftUIApp.swift6//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import SwiftUI
import CoreData
import UserNotifications
import FirebaseCore

@main
struct ToDoSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    init(){
        FirebaseApp.configure()
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error)")
            } else if granted {
                print("Notification permissions granted!")
            } else {
                print("Notification permissions denied.")
            }
        }
    }
}

