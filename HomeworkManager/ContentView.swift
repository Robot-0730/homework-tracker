//
//  ContentView.swift
//  HomeworkManager
//
//  Created by Caleb Herrera vibecoding using Gemini 3.5 Pro on 12/6/2026.
//

import SwiftUI
import CoreML
import SwiftData

// TODO: Split into multiple files
// MARK: Main "view" of the entire app itself.
struct ContentView: View {
    // 1. Get the context to save/delete data
    @Environment(\.modelContext) private var modelContext
    
    // 2. Automatically fetch and sort tasks by highest priority
    @Query(sort: \HomeworkTask.priority, order: .reverse) private var tasks: [HomeworkTask]
    
    // 3. State variables for the "Add New" menu inputs
    @State private var selectedSubject: String = "core"
    @State private var selectedPrep: Int = 0
    @State private var selectedDays: Int = 15
    
    // State for editing
    @State private var taskToEdit: HomeworkTask?
    
    var body: some View {
        ZStack {
            // Background fills everything
            Color.peachCream
                .ignoresSafeArea()
            VStack {
                // Title
                Text("Homework Tracker")
                    .monospaced()
                    .bold()
                    .font(.largeTitle)
                
                Grid {
                    // Header Row
                    GridRow {
                        Text("  ") // Priority indicator
                            .bold()
                        Text("Subject")
                            .bold()
                        Text("Prep")
                            .bold()
                        Text("Days")
                            .bold()
                        Text("Actions")
                            .bold()
                    }
                    
                    Divider()
                    
                    // Sorted Tasks GridRows
                    ForEach(Array(zip(tasks.indices, tasks)), id: \.1.id) { index, task in
                        GridRow {
                            // Display the chronological order (index + 1) instead of raw priority
                            Text("\(index + 1)")
                                .fontWeight(.heavy)
                            
                            Text(task.subject.capitalized)
                            Text("\(task.preparation)")
                            Text("\(task.daysLeft)")
                            
                            HStack(spacing: 12) {
                                Button {
                                    taskToEdit = task
                                } label: {
                                    Image(systemName: "pencil").foregroundColor(.primary)
                                }
                                
                                Button {
                                    modelContext.delete(task)
                                } label: {
                                    Image(systemName: "trash").foregroundColor(.red)
                                }
                            }
                        }
                        // NEW: Color the entire row based on the hidden priority score
                        .foregroundColor(colorForPriority(task.priority))
                    }
                    
                    // Human encouraging other humans.
                    if tasks.isEmpty {
                        Text("Well done!")
                            .padding(.top, 1)
                    }
                    
                    Divider()
                    
                    // Input Menus GridRow
                    GridRow {
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.peach)
                        }
                        
                        Picker("Subject", selection: $selectedSubject) {
                            Text("Core").tag("core")
                            Text("Elective").tag("elective")
                        }
                        .menuStyle()
                        
                        Picker("Prep", selection: $selectedPrep) {
                            ForEach(0..<6) { Text("\($0)").tag($0) }
                        }
                        .menuStyle()
                        
                        Picker("Days", selection: $selectedDays) {
                            ForEach(0..<30) { Text("\($0)").tag($0) }
                        }
                        .menuStyle()
                    }
                }
                // AI styling isn't that good yet... this makes it look really good.
                .padding()
                .monospaced()
                .border(Color.peach, width: 3)
                .background(Color.cream)
                .background(
                    Rectangle()
                        .border(Color.peach, width: 3)
                        .foregroundStyle(Color.clear)
                        .offset(x: 3, y: 3)
                )
                .frame(maxWidth: 380)
            }
        }
        // Attach the edit sheet
        .sheet(item: $taskToEdit) { task in
            EditTaskView(task: task)
        }
    }
    
    // MARK: Function to run CoreML and add the task
    func addTask() {
        do {
            let config = MLModelConfiguration()
            // Replace with your exact model class name
            let model = try TaskPriorityModel(configuration: config)
            
            let prediction = try model.prediction(
                subject: selectedSubject,
                preparation: Int64(selectedPrep),
                daysDue: Int64(selectedDays)
            )
            
            let predictedPriority = Int(prediction.priority.rounded())
            
            let newTask = HomeworkTask(
                subject: selectedSubject,
                preparation: selectedPrep,
                daysLeft: selectedDays,
                priority: predictedPriority
            )
            
            // 3. Save to SwiftData instead of appending to an array
            modelContext.insert(newTask)
            
        } catch {
            print("Error making prediction: \(error)")
        }
    }
    
    // NEW: Helper function to determine row color based on hidden priority
    func colorForPriority(_ priority: Int) -> Color {
        switch priority {
        case 8...: // Bug here, go from 8 to infinity cuz model goes above 10
            return .red // Extremely urgent
        case 4...7:
            return .orange // Moderate
        default:
            return .green // Low urgency
        }
    }
}



// Helper extension to keep the picker styling clean
extension View {
    func menuStyle() -> some View {
        self.pickerStyle(MenuPickerStyle())
            .tint(.primary)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
    // Didn't see this non-error until I read the docs about modelcontainers.
        .modelContainer(for: HomeworkTask.self)
}
