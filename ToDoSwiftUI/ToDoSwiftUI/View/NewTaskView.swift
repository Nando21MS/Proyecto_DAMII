//
//  NewTaskView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 3/12/24.
//

import SwiftUI

struct NewTaskView: View {
    @State var title: String = ""
    @State var details: String = ""
    @State var reminderDate: Date? = nil
    @State var priority: String = "Low"
    @State var category: String = "Work"
    @State var enableReminder: Bool = false // Nuevo estado para habilitar/deshabilitar recordatorio
    @Environment(\.dismiss) var dismiss

    let onSave: (String, String, Date?, String, String) -> Void

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
        .navigationTitle("New Task")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // Si el recordatorio está habilitado, usamos la fecha predeterminada o la configurada
                    let finalReminderDate = enableReminder ? (reminderDate ?? Date()) : nil
                    onSave(title, details, finalReminderDate, priority, category)
                    dismiss() // Cierra la vista después de guardar
                }
            }
        }
    }
}

#Preview {
    NewTaskView(
        onSave: { title, details, reminderDate, priority, category in
            // Aquí puedes manejar la acción de guardar
            print("New task created with title: \(title), details: \(details), reminderDate: \(String(describing: reminderDate)), priority: \(priority), category: \(category)")
        }
    )
}
