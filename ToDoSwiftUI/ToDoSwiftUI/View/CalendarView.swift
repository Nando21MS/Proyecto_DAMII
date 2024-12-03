import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    @State private var tasksForSelectedDate: [Task] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                calendarHeaderView
                taskListView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .onChange(of: [selectedDay, selectedMonth]) { _ in
                filterTasksForSelectedDate()
            }
        }
    }

    private var calendarHeaderView: some View {
        VStack(spacing: 16) {
            // Título con ícono
            HStack(spacing: 8) { // Espacio entre el texto y el ícono
                Image(systemName: "calendar") // Cambia el nombre del ícono según lo necesites
                    .font(.system(size: 40)) // Tamaño del ícono
                    .foregroundColor(.primary) // Color del ícono

                Text("Calendar")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.primary)
            }

            HStack(spacing: 16) {
                monthPicker
                dayPicker
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        }
        .padding(20)

    }

    private var monthPicker: some View {
        Picker("Month", selection: $selectedMonth) {
            ForEach(1...12, id: \.self) { month in
                Text(Calendar.current.monthSymbols[month - 1]).tag(month)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .frame(maxWidth: .infinity)
    }

    private var dayPicker: some View {
        Picker("Day", selection: $selectedDay) {
            ForEach(daysInMonth(for: selectedMonth, year: selectedYear), id: \.self) { day in
                Text("\(day)").tag(day)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .frame(maxWidth: 80)
    }

    private var taskListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tasks for Selected Date")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            if tasksForSelectedDate.isEmpty {
                Text("No tasks for this day")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                List(tasksForSelectedDate) { task in
                    taskRow(for: task)
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: 600)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }

    private func taskRow(for task: Task) -> some View {
        NavigationLink(destination: TaskDetailOnlyView(
            title: task.title ?? "",
            details: task.details ?? "",
            reminderDate: task.reminderDate,
            priority: task.priority ?? "",
            category: task.category ?? ""
        )) {
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title ?? "No Title")
                    .font(.headline)
                    .lineLimit(1)
                if let reminder = task.reminderDate {
                    Text("Reminder: \(reminder, formatter: DateFormatter.shortDateTimeFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }


    private func filterTasksForSelectedDate() {
        let selectedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay))!
        tasksForSelectedDate = viewModel.tasks.filter { task in
            guard let reminderDate = task.reminderDate else { return false }
            return Calendar.current.isDate(reminderDate, inSameDayAs: selectedDate)
        }
    }

    private func daysInMonth(for month: Int, year: Int) -> [Int] {
        var components = DateComponents()
        components.year = year
        components.month = month

        let calendar = Calendar.current
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        return Array(range)
    }
}

#Preview {
    CalendarView()
}