//
//  AssignmentList.swift
//  Assignment Notebook
//
//  Created by Tyler Berlin on 1/24/25.
//

import Foundation

class AssignmentList: ObservableObject {
    @Published var items : [AssignmentItem] {
        didSet {
            if let encodedData = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encodedData, forKey: "data")
            }
        }
    }
    
    @Published var selectedSortOption: String = "Course"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "data") {
            if let decodedData = try? JSONDecoder().decode([AssignmentItem].self, from: data) {
                items = decodedData
                return
            }
        }
        items = []
    }
    var sortedAssignments: [AssignmentItem] {
        if selectedSortOption == "Course" {
            return items.sorted { $0.course < $1.course }
        } else {
            return items.sorted { $0.dueDate < $1.dueDate }
        }
    }
    
    func changeSortOption(to option: String) {
        selectedSortOption = option
    }
    
    func addAssignment(course: String, description: String, dueDate: Date) {
        let item = AssignmentItem(id: UUID(), course: course, description: description, dueDate: dueDate)
        items.append(item)
    }
}

