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
                Label("Taks", systemImage: "note.text")
            }
            CalendarView().tabItem {
                Label("Calendar", systemImage: "calendar")
            }
        }
    }
}

#Preview {
    HomeView()
}
