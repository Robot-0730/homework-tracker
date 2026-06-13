import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var task: HomeworkTask
    
    var body: some View {
        ZStack {
            // 1. Color the entire backdrop of the sheet
            Color.peachCream
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Custom Title Header
                Text("EDIT TASK")
                    .font(.headline)
                    .bold()
                    .padding(.bottom, 5)
                
                // Custom Input Fields Container
                VStack(alignment: .leading, spacing: 20) {
                    // Subject Picker
                    HStack {
                        Text("Subject:").bold()
                        Spacer()
                        Picker("Subject", selection: $task.subject) {
                            Text("Core").tag("core")
                            Text("Elective").tag("elective")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(.primary)
                    }
                    
                    Divider()
                        .background(Color.peach)
                    
                    // Preparation Stepper
                    Stepper(value: $task.preparation, in: 0...5) {
                        HStack {
                            Text("Prep Level:").bold()
                            Text("\(task.preparation)")
                        }
                    }
                    
                    Divider()
                        .background(Color.peach)
                    
                    // Days Left Stepper
                    Stepper(value: $task.daysLeft, in: 0...30) {
                        HStack {
                            Text("Days Left:").bold()
                            Text("\(task.daysLeft)")
                        }
                    }
                }
                .padding()
                // 2. The exact same border box logic from your ContentView
                .border(Color.peach, width: 3)
                .background(Color.cream)
                .background(
                    Rectangle()
                        .border(Color.peach, width: 3)
                        .foregroundStyle(Color.clear)
                        .offset(x: 3, y: 3)
                )
                
                // Done Button styled to match the theme
                Button(action: { dismiss() }) {
                    Text("DONE")
                        .bold()
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .border(Color.peach, width: 3)
                        .background(Color.cream)
                        .background(
                            Rectangle()
                                .border(Color.peach, width: 3)
                                .foregroundStyle(Color.clear)
                                .offset(x: 2, y: 2)
                        )
                }
                .tint(.primary)
                .padding(.top, 10)
            }
            .padding(25)
            .monospaced() // Keeps your consistent font style
        }
        // 3. Ensures iOS doesn't force a default background behind your ZStack
        .presentationBackground(Color.peachCream)
        .presentationDetents([.medium])
    }
}
