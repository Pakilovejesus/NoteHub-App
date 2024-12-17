//
//  ContentView.swift
//  NoteHub
//
//  Created by Pasquale Mirabelli on 17/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var notes: [String] = []
    @State private var newNotes: String = ""
    @State private var isEditing: Bool = false
    @State private var editNoteIndex: Int?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notes.indices, id: \.self) { index in
                        HStack {
                            Text(notes[index])
                                .onTapGesture {
                                    startEditing(note: notes[index], at: index)
                                }
                        }
                    }
                    .onDelete(perform: deleteNote)
                }
                
                HStack {
                    TextField("New note", text: $newNotes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addNote) {
                        Text("Add")
                    }
                }
                .padding()
            }
            .navigationTitle("NoteHub")
            .sheet(isPresented: $isEditing) {
                EditNoteView(note: $newNotes, isEditing: $isEditing) {
                    if let index = editNoteIndex {
                        notes[index] = newNotes
                    }
                }
            }
        }
    }
    
    private func addNote() {
        if !newNotes.isEmpty {
            notes.append(newNotes)
            newNotes = ""
        }
    }
    
    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    private func startEditing(note: String, at index: Int) {
        newNotes = note
        editNoteIndex = index
        isEditing = true
    }
}

struct EditNoteView: View {
    @Binding var note: String
    @Binding var isEditing: Bool
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Edit note", text: $note)
            }
            .navigationBarItems(leading: Button("Cancel") {
                isEditing = false
            }, trailing: Button("Save") {
                onSave()
                isEditing = false
            })
            .navigationTitle("Edit Note")
        }
    }
}

#Preview {
    ContentView()
}
