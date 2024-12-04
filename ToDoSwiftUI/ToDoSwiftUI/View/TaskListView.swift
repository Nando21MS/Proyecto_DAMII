//
//  ContentView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var selectedCategory: String = "All" // Categoría seleccionada

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Filtros de categorías
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        Text("Work").tag("Work")
                        Text("Study").tag("Study")
                        Text("Home").tag("Home")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    // Listado de tareas filtradas
                    List {
                        ForEach(filteredTasks) { task in
                            NavigationLink(destination: TaskDetailView(
                                title: task.title ?? "",
                                details: task.details ?? "",
                                reminderDate: task.reminderDate,
                                priority: task.priority ?? "Low",
                                category: task.category ?? "Work"
                            ) { newTitle, newDetails, newReminderDate, newPriority, newCategory in
                                viewModel.updateTask(
                                    task: task,
                                    newTitle: newTitle,
                                    newDetails: newDetails,
                                    newReminderDate: newReminderDate,
                                    priority: newPriority,
                                    category: newCategory
                                )
                            }) {
                                VStack(alignment: .leading) {
                                    Text(task.title ?? "No Title")
                                        .font(.headline)
                                    if let reminder = task.reminderDate {
                                        Text("Reminder: \(reminder, formatter: DateFormatter.shortDateTimeFormatter)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { viewModel.deleteTask(task: viewModel.tasks[$0]) }
                        }
                    }

                    // Botón flotante
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: NewTaskView(
                            onSave: { title, details, reminderDate, priority, category in
                                viewModel.addTask(title: title, details: details, reminderDate: reminderDate, priority: priority, category: category)
                            }
                        )) {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 10)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Tasks") // Limpia el espacio predeterminado
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer()
                        Image(systemName: "person.circle")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                            .padding(.top, 90)
                    }
                    .padding(.trailing, 10)
                }
            }

        }
    }

    // Computed property para filtrar tareas según la categoría seleccionada
    private var filteredTasks: [Task] {
        if selectedCategory == "All" {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter { $0.category == selectedCategory }
        }
    }
}

extension DateFormatter {
    static var shortDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    TaskListView()
}
