//
//  HomeScreen.swift
//  Verse
//
//  Created by Muhammad Saleh on 05/01/2024.
//

import SwiftUI
import Foundation
import CoreData

struct HomeScreen: View {
    @State var openNoteSheet = false
    @State private var note = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    func addNote(){
        let newNote = Item(context:viewContext)
        newNote.text = note
        newNote.timestamp = Date()
        print(note)
        do {
            try viewContext.save()
        } catch  {
            
        }
        openNoteSheet.toggle()
        
    }
    
    var body: some View {
        NavigationStack {
            LinearGradient(colors: [Color.colorBlue, Color.colorPurple], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)).ignoresSafeArea(.all).overlay {
                ZStack(alignment: .center) {
                    
                    VStack {
                        if items.count > 0 {
                            List {
                                ForEach(items) { item in
                                    NavigationLink {
                                        Text(item.text ?? "")
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(item.text ?? "").lineLimit(3)
                                            Text(item.timestamp!, formatter: itemFormatter).font(.caption).padding(.top)
                                        }
                                    }
                                }.onDelete(perform: deleteItems)
                                    .listRowBackground(Color(UIColor.systemBackground).opacity(0.2))
                                
                            }.scrollContentBackground(.hidden)
                                .listRowBackground(Color.clear)
                            
                        } else {
                            VStack {
                                Text("Start Journaling").font(.title2).fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Create your personal journal.")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .opacity(0.8)
                                    .foregroundColor(.white)
                                
                                Text("Tap the plus button to get started.")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .opacity(0.8)
                                    .foregroundColor(.white)
                            }
                            
                        }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                openNoteSheet.toggle()
                            }label:{
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 80, height: 80)
                            .background(.colorBlue)
                            .cornerRadius(50).contentMargins(12)
                            .padding(.horizontal)
                        }
              
                    }                    
                }
            }
            .navigationTitle("Verse")
        }.sheet(isPresented: $openNoteSheet, content: {
            NavigationStack {
                TextEditor(text: $note)
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                note = ""
                                openNoteSheet.toggle()
                                
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button {
                                addNote()
                            }label: {
                                Image(systemName: "checkmark").tint(.accentColor)
                            }
                        }
                    }
            }
        })
        
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {

            }
        }
    }
    
}

#Preview {
    HomeScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
