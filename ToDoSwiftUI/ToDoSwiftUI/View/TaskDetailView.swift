//
//  TaskDetailView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import SwiftUI

struct TaskDetailView: View {
    @State var title: String
    @State var details: String
    @State var reminderDate: Date?
    @State var priority: String = "Low"
    @State var category: String = "Work"
    @State var enableReminder: Bool // Nuevo estado para habilitar/deshabilitar el recordatorio
    @Environment(\.dismiss) var dismiss

    let onSave: (String, String, Date?, String, String) -> Void

    init(title: String, details: String, reminderDate: Date?, priority: String, category: String, onSave: @escaping (String, String, Date?, String, String) -> Void) {
        self._title = State(initialValue: title)
        self._details = State(initialValue: details)
        self._reminderDate = State(initialValue: reminderDate)
        self._priority = State(initialValue: priority)
        self._category = State(initialValue: category)
        self._enableReminder = State(initialValue: reminderDate != nil) // Activar según si existe un recordatorio
        self.onSave = onSave
    }

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Task Title", text: $title)
            }

            Section(header: Text("Details (Opcional)")) {
                TextEditor(text: $details)
                    .frame(height: 100)
            }

            Section {
                Toggle("Enable Reminder", isOn: $enableReminder)
                    .onChange(of: enableReminder) { isOn in
                        if isOn && reminderDate == nil {
                            // Asignar una fecha predeterminada si no hay una configurada
                            reminderDate = Date()
                        } else if !isOn {
                            // Limpiar la fecha si se desactiva
                            reminderDate = nil
                        }
                    }
                
                if enableReminder {
                    DatePicker(
                        "Set Reminder",
                        selection: Binding(
                            get: { reminderDate ?? Date() },
                            set: { reminderDate = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            } header: {
                Text("Reminder")
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Category")) {
                Picker("Category", selection: $category) {
                    Text("Work").tag("Work")
                    Text("Study").tag("Study")
                    Text("Home").tag("Home")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // Si el recordatorio está habilitado, usar la fecha configurada o la predeterminada
                    let finalReminderDate = enableReminder ? (reminderDate ?? Date()) : nil
                    onSave(title, details, finalReminderDate, priority, category)
                    dismiss() // Cierra la vista después de guardar
                }
            }
        }
    }
}

#Preview {
    TaskDetailView(
        title: "Sample Task",
        details: "This is a sample task description.",
        reminderDate: Date(),
        priority: "Medium",
        category: "Work"
    ) { title, details, reminderDate, priority, category in
        // Acción de ejemplo para guardar
        print("Task updated with title: \(title), details: \(details), reminderDate: \(String(describing: reminderDate)), priority: \(priority), category: \(category)")
    }
}
