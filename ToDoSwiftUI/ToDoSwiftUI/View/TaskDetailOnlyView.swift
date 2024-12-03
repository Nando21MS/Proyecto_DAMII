import SwiftUI

struct TaskDetailOnlyView: View {
    @State var title: String
    @State var details: String
    @State var reminderDate: Date?
    @State var priority: String = "Low"
    @State var category: String = "Work"
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Task Title", text: $title)
                    .disabled(true) // Deshabilita la edición
            }
            
            Section(header: Text("Details")) {
                TextEditor(text: $details)
                    .frame(height: 100)
                    .disabled(true) // Deshabilita la edición
            }
            
            Section(header: Text("Reminder")) {
                DatePicker("Set Reminder", selection: Binding(
                    get: { reminderDate ?? Date() },
                    set: { reminderDate = $0 }
                ), displayedComponents: [.date, .hourAndMinute])
                .disabled(true) // Deshabilita la edición
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(true) // Deshabilita la edición
            }
            
            Section(header: Text("Category")) {
                Picker("Category", selection: $category) {
                    Text("Work").tag("Work")
                    Text("Study").tag("Study")
                    Text("Home").tag("Home")
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(true) // Deshabilita la edición
            }
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TaskDetailOnlyView(
        title: "Sample Task",
        details: "This is a sample task description.",
        reminderDate: nil,
        priority: "Low",
        category: "Work"
    )
}
