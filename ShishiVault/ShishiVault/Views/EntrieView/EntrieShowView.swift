//
//  EntrieAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct EntrieShowView: View {
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @Binding var entrieShowView: Bool
    var entry: EntryData
    
    @State private var isPasswordVisible: Bool = false
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    @State private var notes: String = ""
    @State private var website: String = ""
    
    
    var body: some View {
        List {
            LazyVGrid(
                columns: [GridItem(.flexible())],
                alignment: .leading,
                spacing: 10
            ) {
                Group {
                    Text("Titel:")
                        .normalerTextBold()
                    Text(entry.title)
                        .normalerText()
                    
                    Text("Nutzername:")
                        .normalerTextBold()
                    Text(entry.username ?? "")
                        .normalerText()
                    
                    Text("E-Mail:")
                        .normalerTextBold()
                    Text(entry.email)
                        .normalerText()
                    
                    Text("Website:")
                        .normalerTextBold()
                    Text(entry.website ?? "")
                        .normalerText()
                    
                    Text("Passwort:")
                        .normalerTextBold()
                    Text(isPasswordVisible ? entry.password : "*********")
                        .normalerText()
                        .onTapGesture {
                            isPasswordVisible.toggle()
                        }
                    
                    Text("Notizen:")
                        .normalerTextBold()
                    Text(entry.notes ?? "")
                        .normalerText()
                }
                
                ForEach(entry.customFields ) { fields in
                    Text("\(fields.name):")
                        .normalerTextBold()
                    Text(fields.value)
                        .normalerText()
                }
            }
            
            Text("Erstellt am:")
                .normalerTextBold()
            Text(entry.created.formatted(.dateTime))
                .normalerText()
            
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Edit
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Löschen
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        
        .navigationTitle("Details")
    }
}
