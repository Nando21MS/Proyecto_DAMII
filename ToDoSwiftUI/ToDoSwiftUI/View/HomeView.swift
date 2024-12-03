//
//  HomeView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 3/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            TaskListView().tabItem {
                Label("Notas", systemImage: "note.text")
            }
            TaskListView().tabItem {
                Label("Calendario", systemImage: "calendar")
            }
        }
    }
}

#Preview {
    HomeView()
}
