//
//  ContentView.swift
//  Assignment Notebook
//
//  Created by Tyler Berlin on 1/23/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var assignmentList = AssignmentList()
    @State private var showingAddItemView = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Sort by Course") {
                        assignmentList.changeSortOption(to: "Course")
                    }
                    .padding()
                    .background(assignmentList.selectedSortOption == "Course" ? Color.black : Color.clear)
                    .cornerRadius(8)
                    
                    Button("Sort by Due Date") {
                        assignmentList.changeSortOption(to: "Due Date")
                    }
                    .padding()
                    .background(assignmentList.selectedSortOption == "Due Date" ? Color.black : Color.clear)
                    .cornerRadius(8)
                }
                .padding()
                
                List {
                    ForEach(assignmentList.sortedAssignments) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.course).font(.headline)
                                Text(item.description)
                            }
                            Spacer()
                            Text(item.dueDate, style: .date)
                        }
                        .padding()
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    }
                    .onMove(perform: { indices, newOffset in
                        assignmentList.items.move(fromOffsets: indices, toOffset: newOffset)
                    })
                    .onDelete(perform: { indexSet in
                        assignmentList.items.remove(atOffsets: indexSet)
                    })
                }
            }
            .sheet(isPresented: $showingAddItemView, content: {
                AddAssignmentView(assignmentList: assignmentList)
            })
            .navigationBarTitle("Assignment Notebook", displayMode: .inline)
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                showingAddItemView = true
            }, label: {
                Image(systemName: "plus")
            }))
        }
    }
}

#Preview {
    ContentView()
}

struct AssignmentItem: Identifiable, Codable {
    var id = UUID()
    var course = String()
    var description = String()
    var dueDate = Date()
}
