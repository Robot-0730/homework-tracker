//
//  HomeworkTask.swift
//  HomeworkManager
//
//  Created by Caleb Herrera on 13/6/2026.
//
import SwiftData

@Model
class HomeworkTask {
    var subject: String
    var preparation: Int
    var daysLeft: Int
    var priority: Int
    
    init(subject: String, preparation: Int, daysLeft: Int, priority: Int) {
        self.subject = subject
        self.preparation = preparation
        self.daysLeft = daysLeft
        self.priority = priority
    }
}
